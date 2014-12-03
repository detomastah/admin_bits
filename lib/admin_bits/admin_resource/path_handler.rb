class AdminBits::AdminResource::PathHandler
  attr_reader :path, :request_params

  def initialize(path, request_params)
    @request_params = request_params
    if path.is_a?(Proc)
      @path = routes.instance_exec(request_params, &path)
    elsif path.is_a?(String)
      @path = path
    else
      unknown_argument_type
    end
  end

  def with_params(params = {})
    path + "?" + request_params.merge(params).to_param
  end

  def routes
    Rails.application.routes.url_helpers
  end

  def unknown_argument_type
    raise "Wrong type of argument"
  end
end
