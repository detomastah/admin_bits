class Admin::ItemsController < ApplicationController
  include AdminBits

  declare_resource :items,
    :path => :admin_items_path,
    :ordering => {
      :name => "items.name"
    },
    :default_order => :name,
    :default_direction => :asc

  def index
    head :ok
  end
end
