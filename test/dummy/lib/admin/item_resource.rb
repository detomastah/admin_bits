class Admin::ItemResource < AdminBits::Resource
  filters :having_name, :price_between
  ordering :by_each_attribute, default: { by_price: :asc }

  def resource
    Item
  end

  def path
    admin_items_path
  end

  def having_name(resource)
    resource.having_name(filter_params[:having_name])
  end

  def price_between(resource)
    resource
  end
end
