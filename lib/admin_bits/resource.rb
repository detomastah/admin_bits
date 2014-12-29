module AdminBits::Resource
  def initialize(params)
    @params = params
  end

  def fetch_for_index
    admin_resource.output
  end

  def filter_params
    admin_resource.filter_params
  end
end
