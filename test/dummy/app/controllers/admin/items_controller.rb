class Admin::ItemsController < Admin::BaseController

  def index
    @items = resource.fetch_for_index
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
  end

  private

  def resource
    @resource ||= Admin::ItemResource.new(params)
  end
end
