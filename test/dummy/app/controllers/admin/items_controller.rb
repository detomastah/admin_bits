class Admin::ItemsController < ApplicationController
  include AdminBits

  declare_resource :items,
    :path => :admin_items_path,
    :ordering => {
      :name => "items.name",
      :price => "items.price"
    },
    :default_order => :price,
    :default_direction => :desc

  def index
    @items = Item
  end
end
