class Admin::OrdersController < Admin::BaseController
  authorize_resource

  before_action :check_order, only: [:update]
  def index
    @pagy, @orders = pagy(
      Order.all.order_by_updated_at,
      items: Settings.page.size_5
    )
    filter_params(params).each do |key, value|
      @orders = @orders.public_send("filter_by_#{key}", value) if value.present?
    end
  end

  def update
    if status_params.to_i < Order.statuses[@order.status] ||
       gap(status_params, Order.statuses[@order.status]) > 1
      flash[:danger] = t "admin.order.update.fail"
    else
      @order.update(status: status_params.to_i)
      flash[:success] = t "admin.order.update.success"
    end
    redirect_to admin_orders_path
  end

  private

  def gap change_status, current_status
    (change_status.to_i - current_status).abs
  end

  def status_params
    params.require(:status)
  end

  def filter_params params
    params.slice(:customer, :status)
  end

  def check_order
    return if @order = Order.find_by(id: params[:id])

    flash[:danger] = t "admin.order.not_found"
    redirect_to admin_orders_path
  end
end
