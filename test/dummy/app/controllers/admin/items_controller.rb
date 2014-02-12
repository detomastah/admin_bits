class Admin::ItemsController < ApplicationController
  include AdminBits

  declare_resource :items do
    path :admin_items_path
    ordering({
      :name => "items.name",
      :price => "items.price"
    })
    default_order :price
    default_direction :desc
    filters({
      :having_name => [:name],
      :price_within => [:from, :to]
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
