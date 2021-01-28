class MenuItemsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :ensure_user_logged_in, only: [:index, :show]

  def index
    render plain: MenuItem.all.map { |item| item.to_string }.join("\n")
  end

  def show
    render plain: MenuItem.find(params[:id]).to_string
  end

  def create
    new_menu_item = MenuItem.new({
      menu_id: params[:menu_id],
      name: params[:name],
      description: params[:description],
      price: params[:price],
    })
    if new_menu_item.save
      render plain: new_menu_item.to_string
    else
      render plain: new_menu_item.errors.full_messages.join("\n")
    end
  end

  def update
    id = params[:id]
    name = params[:name]
    description = params[:description]
    price = params[:price]
    new_menu_item = MenuItem.find(id)

    new_menu_item.name = name if name
    new_menu_item.description = description if description
    new_menu_item.price = price if price

    if new_menu_item.save
      render plain: new_menu_item.to_string
    else
      render plain: new_menu_item.errors.full_messages.join("\n")
    end
  end

  def destroy
    id = params[:id]
    menu_item = MenuItem.find(id)
    menu_item.destroy
    render plain: "DELETED MENU_ITEM WITH ID #{id}"
  end
end
