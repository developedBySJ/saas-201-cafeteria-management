class CartsController < ApplicationController
  def index
    cart_items = Cart.of_user(@current_user.id)
    total = cart_items.reduce(0) { |total, cur| total + MenuItem.find(cur.menu_item_id).price * cur.qty }
    render "carts/index", :locals => { cart_items: cart_items, total: total }
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
        flash[:success] = ["Menu Item Added To Cart"]
        redirect_to "/"
      else
        error = result.errors.full_messages
        flash[:error] = error[0...3]
        redirect_to "/"
      end
    else
      flash[:error] = ["menu item does not exits"]
      redirect_to "/"
    end
  end

  def destroy
    id = params[:id]
    user_id = @current_user.id
    cart = Cart.find_by(id: id, user_id: user_id)
    if cart
      cart.destroy
    end
    redirect_to "/checkout"
  end

  def update
    id = params[:id]
    user_id = @current_user.id
    cart = Cart.find_by(id: id, user_id: user_id)
    qty = params[:qty]
    if Integer(qty) < 1
      cart.destroy
    else
      cart.qty = qty
      if cart.save
        flash[:success] = ["Cart updated successfully"]
      else
        error = cart.errors.full_messages
        flash = error[0...3]
      end
    end
    redirect_to "/checkout"
  end
end
