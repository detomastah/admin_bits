module AdminBits
  class ParamsHandler
    attr_reader :options, :resource, :request_params

    def initialize(options, request_params = {})
      @resource       = options.resource
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
      options.default_order[:method]
    end

    def default_asc
      options.default_order[:direction] == :asc ? "true" : "false"
    end

    def filter_params
      (request_params[:filters] || {}).with_indifferent_access
    end

    def filtered_resource
      return_scope = resource
      options.filter_methods.each do |method_name|
        method_param = request_params[:filters].try :fetch, method_name, nil

        if method_param.present? && ((not method_param.is_a? Hash) || method_param.values.any?(&:present?))
          return_scope = options.send(method_name, return_scope)
        end
      end

      return_scope
    end

    def output
      return filtered_resource unless request_params[:order]
      # Paginator.new(filtered_resource.order(get_order), get_page).call
      options.send(get_order, filtered_resource, get_direction) #.page(get_page)
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
