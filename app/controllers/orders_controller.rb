class OrdersController < ApplicationController
  before_action except: [:index, :pending, :show, :create, :update, :destroy] do
    limit_access_to(["admin"])
  end
  before_action except: [:index, :show, :create] do
    limit_access_to(["admin", "clerk"])
  end

  def index
    orders = []
    user = @current_user
    if user.role == "admin"
      orders = Order.all
    elsif user.role == "clerk"
      return redirect_to orders_pending_path
    else
      orders = Order.of_user(user.id)
    end
    render "orders/index", :locals => { orders: orders.order(created_at: :desc) }
  end

  def show
    id = params[:id]
    order_details = Order.find(id)
    if (@current_user.role == "admin" || @current_user.id == order_details.user_id)
      order_items = OrderItem.of_order(id)
      render "orders/invoice", :locals => { order: order_details, order_items: order_items }
    else
      redirect_to "/dashboard"
    end
  end

  def pending
    orders = Order.pending_orders
    render "orders/pending", :locals => { orders: orders.order(created_at: :asc) }
  end

  def create
    user_name = @current_user.role == "customer" ? "#{@current_user.first_name} #{@current_user.last_name}" : "Walk in customer"
    cart = Cart.of_user(@current_user.id)
    if cart.count < 1
      flash[:error] = ["Add At Least One Item To Cary"]
      return redirect_to "/"
    end
    total = cart.reduce(0) { |total, cur| total + MenuItem.find(cur.menu_item_id).price * cur.qty }
    new_order = Order.new({
      total_price: total,
      user_id: @current_user.id,
      user_name: user_name,
    })
    if new_order.save
      order = cart.map do |item|
        menu_item = MenuItem.find(item.menu_item_id)
        order_item = {
          order_id: new_order.id,
          menu_item_id: menu_item.id,
          menu_item_name: menu_item.name,
          menu_item_price: menu_item.price,
          qty: item.qty,
        }
        order_item
      end
      order_items = OrderItem.create(order)
      Cart.of_user(@current_user.id).destroy_all
      flash[:success] = ["Order created successfully"]
      redirect_to order_path(new_order.id)
    else
      flash[:error] = ["Unable to create order please try again later"]
      redirect_to "/checkout"
    end
  end

  def update
    # if (@current_user.role == "admin")
    id = params[:id]

    delivered_at = params[:delivered_at]
    order = Order.find(id)
    order.delivered_at = delivered_at ? Time.parse(delivered_at) : Time.now
    order.save
    flash[:success] = ["Order with id ##{order.id} updated successfully"]
    redirect_to orders_path
    # else
    # render plain: "forbidden"
    # end
  end

  def destroy
    id = params[:id]
    order = Order.where({ id: id, delivered_at: nil })
    order.destroy
    flash[:success] = ["Deleted order with id #{order.id}"]
    render order_path
  end
end
