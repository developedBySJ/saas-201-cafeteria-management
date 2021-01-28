class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render plain: Order.all.map { |order| order.to_string }.join("\n")
  end

  def show
    id = params[:id]
    order_details = Order.find(id)
    order_items = OrderItem.of_order(id)
    render plain: "#{order_details.to_string} \n #{order_items.map { |order| order.to_string }.join("\n")}"
  end

  def pending
    render plain: Order.pending_orders.map { |order| "#####{order.id}####\n\n#{OrderItem.of_order(order.id).map { |o| o.to_string }.join("\n")}" }.join("\n")
  end

  def create
    user_id = @current_user.id
    cart = Cart.of_user(user_id)

    if cart.count < 1
      return render plain: "CART IS EMPTY"
    else
      total = cart.reduce(0) { |total, cur| total + MenuItem.find(cur.menu_item_id).price * cur.qty }
      new_order = Order.new({
        total_price: total,
        user_id: user_id,
      })
      new_order.save
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
      x = OrderItem.create(order)
      pp x
      Cart.of_user(user_id).destroy_all
      return render plain: "#{x.map { |order| order.to_string }.join("\n")} \n cart : #{total} "
    end
  end

  def update
    # if (@current_user.role == "admin")
    id = params[:id]

    delivered_at = params[:id]
    order = Order.find(id)
    order.delivered_at = delivered_at ? Time.parse(delivered_at) : Time.now.iso8601()
    order.save
    render plain: order.to_string
    # else
    # render plain: "forbidden"
    # end
  end

  def destroy
    id = params[:id]
    order = Order.find(id)
    order.destroy
    render plain: "deleted"
  end
end
