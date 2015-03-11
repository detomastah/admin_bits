class Admin::ItemResource < AdminBits::Resource
  filters :having_name
  ordering :by_each_attribute, default: { by_price: :asc }
  per_page 4

  def resource
    Item
  end

  def path
    # This should be path to your index action - you can create any path you like
    admin_items_path
  end

  def having_name(resource)
    resource.having_name(filter_params[:having_name])
  end

  def by_id(resource, direction = :asc)
    resource.order("id #{direction}")
  end
end
