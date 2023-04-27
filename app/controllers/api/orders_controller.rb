class Api::OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action except: [:update_status]

  def update_status
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      render json: { error: "Order not found" }, status: :unprocessable_entity
    else
      order_status = OrderStatus.find_by(name: params[:status])
      if order_status.nil?
        render json: { error: "Invalid order status" }, status: :unprocessable_entity
      else
        @order.order_status = order_status
        @order.save
        render json: @order
      end
    end
  end

  def index
    orders = Order.includes(:customer, :restaurant, :order_status)
    
    if !params[:type].in?(["customer", "courier", "restaurant"]) || params[:id].blank?
      render json: { error: "Both 'user type' and 'id' parameters are required" }, status: :bad_request
    elsif !params[:type].in?(["customer", "courier", "restaurant"])
      render json: { error: "Invalid user type" }, status: :unprocessable_entity
    else
      case params[:type]
      when "customer"
        orders = orders.where(customer_id: params[:id])
      when "restaurant"
        orders = orders.where(restaurant_id: params[:id])
      when "courier"
        orders = orders.where(courier_id: params[:id])
      end
  
      orders_data = orders.map do |order|
        {
          id: order.id,
          customer_id: order.customer.id,
          customer_name: order.customer.user.name,
          customer_address: "#{order.customer.address.street_address}, #{order.customer.address.city}, #{order.customer.address.postal_code}",
          restaurant_id: order.restaurant.id,
          restaurant_name: order.restaurant.name,
          restaurant_address: "#{order.restaurant.address.street_address}, #{order.restaurant.address.city}, #{order.restaurant.address.postal_code}",
          courier_id: order.courier_id,
          courier_name: order.courier&.user&.name,
          status: order.order_status.name,
          products: order.product_orders.map do |product_order|
            {
              product_id: product_order.id,
              product_name: product_order.product.name,
              quantity: product_order.product_quantity,
              unit_cost: product_order.product_unit_cost,
              total_cost: product_order.product_unit_cost * product_order.product_quantity
            }
          end,
          total_cost: order.product_orders.sum { |product_order| product_order.product_unit_cost * product_order.product_quantity },
          date: order.created_at
        }
      end
  
      render json: orders_data
    end
  end

  def create
    restaurant_id = params[:order][:restaurant_id]
    customer_id = params[:order][:customer_id]
    courier_id = Courier.all.sample.id # get a random courier id
    product_orders = params[:order][:product_orders]
  
    if restaurant_id.blank? || customer_id.blank? || product_orders.blank?
      render json: { error: "Restaurant ID, customer ID, and products are required" }, status: :bad_request
    else
      restaurant = Restaurant.find_by(id: restaurant_id)
      customer = Customer.find_by(id: customer_id)
  
      if restaurant.nil? || customer.nil?
        render json: { error: "Invalid restaurant or customer ID" }, status: :unprocessable_entity
      else
        order_status = OrderStatus.find_by(name: "pending")
        order = Order.new(restaurant: restaurant, customer: customer, courier_id: courier_id, order_status: order_status)
  
        # Check for invalid product IDs before creating any product orders
        invalid_product_ids = product_orders.select { |po| Product.find_by(id: po[:id]).nil? }.map { |po| po[:id] }
        if invalid_product_ids.present?
          render json: { error: "Invalid product ID" }, status: :unprocessable_entity
        else
          order.save
  
          product_orders.each do |product_order|
            new_product_order = ProductOrder.new(
              product_id: product_order[:id],
              order_id: order.id,
              product_quantity: product_order[:product_quantity],
              product_unit_cost: product_order[:product_unit_cost]
            )
            order.product_orders << new_product_order
          end
  
          if order.save
            response_body = {
              restaurant_id: restaurant.id,
              restaurant_name: restaurant.name,
              customer_id: customer.id,
              customer_name: customer.user.name,
              order_id: order.id,
              courier_id: courier_id,
              product_orders: order.product_orders.map { |po| { id: po.product_id, quantity: po.product_quantity } }
            }
            render json: response_body, status: :created
          else
            render json: { error: order.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    end
  end

end