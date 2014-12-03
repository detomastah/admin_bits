class Admin::ItemsController < ApplicationController
  include AdminBits

  declare_resource :items do
    path { admin_items_path }
    ordering({
      :name => "items.name",
      :price => "items.price"
    })
    default_order :price
    default_direction :desc
    filters({
      # Points to Item#having_name, passes params[:filters][:name] as the only param
      :having_name => [:name],
      # One can define own filter criteria of arbitrary name using lambdas
      :price_between => lambda { |f|
        from = f[:from].present? ? f[:from].to_i : nil
        to   = f[:to].present? ? f[:to].to_i : nil

        ret = where(nil)
        ret = ret.where(["price <= ?", to]) if to
        ret = ret.where(["price >= ?", from]) if from
        ret
      }
    })
    mods BasicAdminPanel
  end

  def index
    @items = Item
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
  end
end
