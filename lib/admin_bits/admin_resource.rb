module AdminBits
  class AdminResource
    attr_reader :options, :resource, :request_params

    def initialize(resource, options, request_params = {})
      @resource       = resource
      @options        = options
      @request_params = request_params

      raise ":path must be provided" unless @options.path

      sanitize_params
    end

    def sanitize_params
      @request_params = request_params.
        with_indifferent_access.
        reject do |k,v|
          ["action", "controller", "commit"].include?(k) || v.blank?
        end
      if request_params[:order]
        request_params[:order]
      else
        request_params[:order] ||= default_order
        request_params[:asc]   ||= default_asc
      end
    end

    def default_order
      options.default_order.first.first
    end

    def default_asc
      options.default_order.first.last == :asc ? "true" : "false"
    end

    def filter_params
      (request_params[:filters] || {}).with_indifferent_access
    end

    def filtered_resource
      return_scope = resource
      (options.filter_methods || []).each do |method_name|
        return_scope = options.send(method_name, return_scope)
      end

      return_scope
    end

    def output
      # Paginator.new(filtered_resource.order(get_order), get_page).call
      options.send(get_order, filtered_resource, get_direction).page(get_page)
    end

    def original_url
      PathHandler.new(options.path, request_params).path
    end

    def url(params = {})
      PathHandler.new(options.path, request_params).with_params(params)
    end

    def get_page
      request_params[:page]
    end

    def get_order
      order = request_params[:order].to_sym

      if options.ordering_methods.include?(order)
        order
      else
        raise "invalid order method"
      end
    end

    def get_direction
      request_params[:asc] != "true" ? "DESC" : "ASC"
    end

    # def convert_mapping(mapping)
    #   # Check if mapping was provided
    #   raise "No order mapping specified for '#{order}'" if mapping.blank?
    #   # Convert to array in order to simplify processing
    #   mapping = [mapping] if mapping.is_a?(String)
    #   # Convert to SQL form
    #   mapping.map {|m| "#{m} #{get_direction}"}.join(", ")
    # end
  end
end
