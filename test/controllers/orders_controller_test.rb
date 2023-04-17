class OrdersControllerTest < ActionDispatch::IntegrationTest

  def setup
    user = User.create!(name: "User 1", email: "test@test.com", password: "password")
    address = Address.create!(street_address: "Street 1", city: "City 1", postal_code: "11111")
    restaurant = Restaurant.create!(user: user, address: address, name: "Restaurant 1", phone: "123456", price_range: 2)
    customer = Customer.create!(user: user, address: address, phone: "123456")
    product = Product.create!(name: "Product 1", cost: 10, restaurant: restaurant)
    order_status = OrderStatus.create(name: "pending")
    OrderStatus.create(name: "in progress")
    OrderStatus.create(name: "delivered")
    @order = Order.create!(restaurant: restaurant, customer: customer, order_status: order_status, restaurant_rating: 4)
  end

  test "update order status to 'pending'" do
    post "/api/order/#{@order.id}/status", params: { status: "pending" }
    assert_response :success
    assert_equal "pending", @order.reload.order_status.name
  end

  test "update order status to 'in progress'" do
    post "/api/order/#{@order.id}/status", params: { status: "in progress" }
    assert_response :success
    assert_equal "in progress", @order.reload.order_status.name
  end

  test "update order status to 'delivered'" do
    post "/api/order/#{@order.id}/status", params: { status: "delivered" }
    assert_response :success
    assert_equal "delivered", @order.reload.order_status.name
  end

  test "return 422 error for invalid status" do
    post "/api/order/#{@order.id}/status", params: { status: "invalid" }
    assert_response 422
  end

  test "return 422 error for invalid order" do
    post "/api/order/0/status", params: { status: "pending" }
    assert_response 422
  end

  # New tests

  # *****  GET  *****

  test "orders route exists and is a GET route" do
    assert_routing({ path: '/api/orders', method: :get }, { controller: 'api/orders', action: 'index' })
  end

  test "returns a list of orders for a given user type and ID" do
    user_type = "customer"
    user_id = @order.customer.id
    get "/api/orders?type=#{user_type}&id=#{user_id}"
    assert_response :success
    response_body = JSON.parse(response.body)
    assert_instance_of Array, response_body
    assert_equal 1, response_body.size
    assert_equal @order.id, response_body.first["id"]
  end

  test "get orders with invalid user type parameter" do
    get "/api/orders?type=#{"big_boss"}&id=#{@order.customer.id}"
    assert_response 422
    assert_equal({ error: "Invalid user type" }.to_json, response.body)
  end

  test "get orders with ID not found" do
    user_type = "customer"
    get "/api/orders?type=#{user_type}&id=#{123456}"
    assert_response 200
    assert_equal([], JSON.parse(response.body))
  end

  test "get orders with invalid user type and ID parameter" do
    get "/api/orders?type=#{"big_boss"}&id=#{123456}"
    assert_response 400
    assert_equal({ error: "Both 'user type' and 'id' parameters are required" }.to_json, response.body)
  end
  
  # *****  POST  *****

  test "orders route exists and is a POST route" do
    assert_routing({ path: '/api/orders', method: :post }, { controller: 'api/orders', action: 'create' })
  end

  test "creates an order with the given details" do
    restaurant = @order.restaurant
    customer = @order.customer
    product1 = Product.create!(name: "Product 1", cost: 9.99, restaurant: restaurant)
    product2 = Product.create!(name: "Product 2", cost: 12.99, restaurant: restaurant)

    order_payload = {
      order: {
        restaurant_id: restaurant.id,
        customer_id: customer.id,
        product_orders: [
          { id: product1.id, product_quantity: 1, product_unit_cost: 9.99 },
          { id: product2.id, product_quantity: 3, product_unit_cost: 12.99 }
        ]
      }
    }
    
    post "/api/orders", params: order_payload
  
    assert_response :success
  
    response_body = JSON.parse(response.body)
    assert_equal restaurant.id, response_body["restaurant_id"]
    assert_equal customer.id, response_body["customer_id"]
    assert_equal 2, response_body["product_orders"].size
    assert_equal product1.id, response_body["product_orders"][0]["id"]
    assert_equal 1, response_body["product_orders"][0]["quantity"]
    assert_equal product2.id, response_body["product_orders"][1]["id"]
    assert_equal 3, response_body["product_orders"][1]["quantity"]
  end

  test "returns an error if restaurant, customer, or product_orders are missing" do
    restaurant = @order.restaurant
    customer = @order.customer
    product1 = Product.create!(name: "Product 1", cost: 9.99, restaurant: restaurant)
    product2 = Product.create!(name: "Product 2", cost: 12.99, restaurant: restaurant)
  
    # Test missing restaurant ID
    order_payload = {
      order: {
        customer_id: customer.id,
        product_orders: [
          { id: product1.id, product_quantity: 1, product_unit_cost: 9.99 },
          { id: product2.id, product_quantity: 3, product_unit_cost: 12.99 }
        ]
      }
    }
    post "/api/orders", params: order_payload
    assert_response :bad_request
    response_body = JSON.parse(response.body)
    assert_equal "Restaurant ID, customer ID, and products are required", response_body["error"]
  
    # Test missing customer ID
    order_payload = {
      order: {
        restaurant_id: restaurant.id,
        product_orders: [
          { id: product1.id, product_quantity: 1, product_unit_cost: 9.99 },
          { id: product2.id, product_quantity: 3, product_unit_cost: 12.99 }
        ]
      }
    }
    post "/api/orders", params: order_payload
    assert_response :bad_request
    response_body = JSON.parse(response.body)
    assert_equal "Restaurant ID, customer ID, and products are required", response_body["error"]
  
    # Test missing product_orders
    order_payload = {
      order: {
        restaurant_id: restaurant.id,
        customer_id: customer.id
      }
    }
    post "/api/orders", params: order_payload
    assert_response :bad_request
    response_body = JSON.parse(response.body)
    assert_equal "Restaurant ID, customer ID, and products are required", response_body["error"]
  end

  test "returns error message for invalid restaurant or customer ID" do
    restaurant = @order.restaurant
    customer = @order.customer
    product1 = Product.create!(name: "Product 1", cost: 9.99, restaurant: restaurant)

    # Set up the order payload with an invalid restaurant ID
    order_payload = {
      order: {
        restaurant_id: 999,
        customer_id: customer.id,
        product_orders: [
          { id: product1.id, product_quantity: 1, product_unit_cost: 9.99 }
        ]
      }
    }
  
    post "/api/orders", params: order_payload
  
    assert_response :unprocessable_entity
  
    response_body = JSON.parse(response.body)
    assert_equal "Invalid restaurant or customer ID", response_body["error"]
  end

  test "returns error message for invalid product ID" do
    restaurant = @order.restaurant
    customer = @order.customer
    product1 = Product.create!(name: "Product 1", cost: 9.99, restaurant: restaurant)

    # Set up the order payload with an invalid product ID
    order_payload = {
      order: {
        restaurant_id: restaurant.id,
        customer_id: customer.id,
        product_orders: [
          { id: 123456, product_quantity: 1, product_unit_cost: 9.99 }
        ]
      }
    }
  
    post "/api/orders", params: order_payload
  
    assert_response :unprocessable_entity
  
    response_body = JSON.parse(response.body)
    assert_equal "Invalid product ID", response_body["error"]
  end

end