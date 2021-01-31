class MenusController < ApplicationController
  before_action do
    limit_access_to(["admin"])
  end

  def index
    menus = Menu.all
    render "menu/index", :locals => { menus: menus }
  end

  def new
    render "menu/new"
  end

  def edit
    id = params[:id]
    menu = Menu.find(id)
    render "menu/edit", :locals => { menu: menu }
  end

  def create
    new_menu = Menu.new({
      name: params[:name],
      is_active: params[:is_active] == "1" ? true : false,
    })
    if new_menu.save
      redirect_to menus_path
    else
      error = new_menu.errors.full_messages
      flash[:error] = error[0...3]
      redirect_to new_menu_path
    end
  end

  def show
    id = params[:id]
    menu = Menu.find(id)
    menu_item_list = MenuItem.of_menu(menu.id)
    # plain: "#{menu.to_string}\n\n#{menu_item_list}"
    render "menu/show", :locals => { menu: menu, menu_items: menu_item_list }
  end

  def update
    id = params[:id]
    name = params[:name]
    is_active = params[:is_active] == "1" ? true : false
    updated_menu = Menu.find(id)

    if name
      updated_menu.name = name
    end
    if is_active == true
      updated_menu.activate!
    end

    if updated_menu.save
      redirect_to menu_path(updated_menu.id)
    else
      error = updated_menu.errors.full_messages
      flash[:error] = error[0...3]
      redirect_to edit_menu_path(updated_menu.id)
    end
  end

  def destroy
    id = params[:id]
    menu = Menu.find(id)
    menu.destroy
    flash[:success] = ["Deleted menu with ID #{id}"]
    redirect_to menus_path
  end
end
