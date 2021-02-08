class SalesController < ApplicationController
  def index
    from_date = params[:from_date] ? params[:from_date] : 1.month.ago
    to_date = params[:to_date] ? params[:to_date] : Time.now
    orders = Order.where("created_at BETWEEN '#{from_date}' AND '#{to_date}'").order("created_at")
    render "sales/index", :locals => { orders: orders }
  end
end
