class Admin::RawResource < AdminBits::Resource
  ordering :plain, default: { plain: :asc}
  filters :even_numbers

  def resource
    [8, 6, 4, 2, 1, 3, 5, 7, 9]
  end

  def path
    admin_raw_path
  end

  def even_numbers(resource)
    resource.select(&:even?)
  end
end
