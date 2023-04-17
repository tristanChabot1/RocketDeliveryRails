class EmployeesController < ApplicationController
  before_action :authenticate_user!, :set_employee, only: [:show, :edit, :update, :destroy]

  def index
    authenticate_user!
    if Employee.find_by(user_id: current_user.id).present?
      @employees = Employee.all
      
    else
      redirect_to root_path
    end
  end

  def show
  end

  def new
    @employee = Employee.new
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)
  
    if @employee.save
      redirect_to @employee
    else
      render :new
    end
  end

  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to employee_url(@employee), notice: "Employee was successfully updated." }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to employees_url, notice: "Employee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_employee
      @employee = Employee.find(params[:id])
    end

    def employee_params
      params.require(:employee).permit(:user_id, :address_id, :phone, :email)
    end
end