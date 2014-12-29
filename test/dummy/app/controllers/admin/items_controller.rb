class Admin::ItemsController < ApplicationController
  helper_method :admin_resource, :admin_filter

  def index
    @item_resource = Admin::ItemResource.new(params)
    @items = @item_resource.fetch_for_index
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
  end

  private

  def admin_resource
    @item_resource.admin_resource
  end

  def admin_filter(name)
    @item_resource.filter_params[name]
  end
end
