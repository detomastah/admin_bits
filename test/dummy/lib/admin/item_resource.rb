class Admin::ItemResource < AdminBits::Resource
  filters :having_name, :price_between
  ordering :by_name, :by_price, default: { by_price: :asc }

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

  def by_name(resource, direction = :asc)
    resource.order("name #{direction}")
  end

  def by_price(resource, direction = :asc)
    resource.order("price #{direction}")
  end
end
