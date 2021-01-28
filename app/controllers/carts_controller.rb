class CartsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render plain: Cart.of_user(@current_user.id).map { |item| item.to_string }.join("\n")
  end

  def show
    id = params[:id]
    cart = Cart.find(id)
    redirect_to "#{menu_items_path}/#{cart.menu_item_id}"
  end

  def create
    menu_item_id = params[:menu_item_id]
    user_id = @current_user.id
    qty = params[:qty] ? params[:qty] : 1
    if MenuItem.exists?(menu_item_id)
      result = Cart.add_to_cart(menu_item_id, user_id, qty)

      if result.save
        render plain: result.to_string
      else
        render plain: result.errors.full_messages.join("\n")
      end
    else
      render plain: "menu item does not exits"
    end
  end

  def destroy
    id = params[:id]
    user_id = @current_user.id
    cart = Cart.find_by(id: id, user_id: user_id)
    cart.destroy
    render plain: "deleted"
  end

  def update
    id = params[:id]
    user_id = @current_user.id
    cart = Cart.find_by(id: id, user_id: user_id)
    cart.qty = params[:qty]
    if cart.save
      render plain: cart.to_string
    else
      render plain: cart.errors.full_messages.join("\n")
    end
  end
end
