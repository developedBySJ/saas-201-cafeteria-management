class MenusController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render plain: Menu.all.map { |item| item.to_string }.join("\n")
  end

  def create
    new_menu = Menu.new({
      name: params[:name],
      is_active: params[:is_active],
    })
    if new_menu.save
      render plain: new_menu.to_string
    else
      render plain: new_menu.errors.full_messages.join("\n")
    end
  end

  def show
    id = params[:id]
    menu = Menu.find(id)
    menu_item_list = MenuItem.of_menu(menu.id).map { |item| item.to_string }.join("\n")
    render plain: "#{menu.to_string}\n\n#{menu_item_list}"
  end

  def update
    id = params[:id]
    name = params[:name]
    is_active = params[:is_active]
    new_menu = Menu.find(id)

    if name
      new_menu.name = name
    end
    if is_active == true
      menu.activate!
    end

    if new_menu.save
      render plain: "#{new_menu.to_string}"
    else
      render plain: new_menu.errors.full_messages.join("\n")
    end
  end

  def destroy
    id = params[:id]
    menu = Menu.find(id)
    menu.destroy
    render plain: "DELETED MENU WITH ID #{id}"
  end
end
