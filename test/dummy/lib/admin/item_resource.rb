class Admin::ItemResource < AdminBits::Resource
  attr_accessor :filtered_resource
  filters :having_name, :price_between
  ordering :by_each_attribute, default: { by_price: :asc }

  def resource
    Item
  end

  def path
    admin_items_path
  end

  def having_name(resource)
    resource.having_name(filter_params[:name])
  end

  def price_between(resource)
    resource
  end

  # scope method
  def have_name(name)
    @filtered_resource = current_resource.having_name(name)
    self
  end


  declare_time_range_scope :time_range, on: :created_at
end
