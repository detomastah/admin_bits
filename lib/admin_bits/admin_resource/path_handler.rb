class AdminBits::AdminResource::PathHandler
  attr_reader :request_params, :unprocessed_path

  def initialize(path, request_params)
    @request_params = request_params
    @unprocessed_path = path
  end

  def path
    @path ||= begin
      if unprocessed_path.is_a?(Proc)
        @path = routes.instance_exec(request_params, &unprocessed_path)
      elsif unprocessed_path.is_a?(String)
        @path = unprocessed_path
      else
        unknown_argument_type
      end
    end
  end

  def with_params(params = {})
    path + "?" + request_params.merge(params).to_param
  end

  private

  def routes
    Rails.application.routes.url_helpers
  end

  def unknown_argument_type
    raise "Wrong type of argument"
  end
end
