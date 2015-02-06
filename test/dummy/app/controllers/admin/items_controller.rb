class Admin::ItemsController < Admin::BaseController
  
  def index
    @items = resource.fetch_for_index
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      flash[:notice] = "You have successfully created item"
      redirect_to admin_items_path
    else
      flash[:alert] = "item can't be created"
      render 'new'
    end
  end

  def edit
    @items = Item.find(params[:id])
  end

  def update
    @items = Item.find(params[:id])
  end

  private

  def resource
    @resource ||= Admin::ItemResource.new(params)
  end

  def item_params
    params.require(:item).permit(:name, :price, :description, :order_id)
  end
end
