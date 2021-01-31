class MenuItemsController < ApplicationController
  skip_before_action :ensure_user_logged_in, only: [:index, :show]
  before_action do
    limit_access_to(["admin"])
  end

  def index
    menu_items = MenuItem.all
    render "menu_item/index", :locals => { menu_items: menu_items }
  end

  def new
    render "menu_item/new"
  end

  def edit
    menu_item = MenuItem.find(params[:id])
    render :template => "menu_item/edit", :locals => { menu_item: menu_item }
  end

  def show
    menu_item = MenuItem.find(params[:id])
    render :template => "menu_item/show", :locals => { menu_item: menu_item }
  end

  def create
    new_menu_item = MenuItem.new({
      menu_id: params[:menu_id],
      name: params[:name],
      description: params[:description],
      image: params[:image],
      is_veg: params[:is_veg],
      prep_time: params[:prep_time],
      price: params[:price],
    })
    if new_menu_item.save
      redirect_to menu_item_url(new_menu_item)
    else
      error = new_menu_item.errors.full_messages
      flash[:error] = error[0...3]
      redirect_to new_menu_item_path
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
      flash[:success] = ["Menu item Updated successfully"]
      redirect_to menu_item_path(new_menu_item.id)
    else
      error = new_menu_item.errors.full_messages
      flash[:error] = error[0...3]
      redirect_to edit_menu_item_path(new_menu_item.id)
    end
  end

  def destroy
    id = params[:id]
    menu_item = MenuItem.find(id)
    menu_item.destroy
    render plain: ["DELETED MENU_ITEM WITH ID #{id}"]
  end
end
