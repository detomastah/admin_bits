class Admin::ItemResource < AdminBits::Resource
  filters :sample_filter_method
  ordering :by_each_attribute, default: { by_id: :asc }

  def resource
    Item
  end

  def path
    # This should be path to your index action - you can create any path you like
    admin_items_path
  end

  def sample_filter_method(resource)
    resource
  end

  def by_id(resource, direction = :asc)
    resource.order("id #{direction}")
  end
end
