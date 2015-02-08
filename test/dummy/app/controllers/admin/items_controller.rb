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
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])

    if @item.update_attributes(item_params)
      flash[:notice] = "You have successfully updated item"
      redirect_to admin_items_path
    else
      flash[:alert] = "item can't be updated"
      render :edit
    end
  end

  def destroy
    @item = Item.find(params[:id])

    @item.destroy
    flash[:notice] = "You have successfully deleted item"
    redirect_to admin_items_path
  end

  private

  def resource
    @resource ||= Admin::ItemResource.new(params)
  end

  def item_params
    params.require(:item).permit(:name, :price, :description, :order_id)
  end
end
