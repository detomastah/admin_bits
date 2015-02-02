class AdminBits::ParamsHandler::Paginator
  attr_reader :resource, :page, :options

  def initialize(resource, page, options)
    @resource = resource
    @page     = page || 1
    @options  = options
  end

  def paginate
    per_page = 30
    resource.slice((page - 1) * per_page, page * per_page)
  end
end
