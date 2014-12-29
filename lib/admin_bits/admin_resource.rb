module AdminBits
  class AdminResource
    attr_reader :options, :resource, :request_params, :action_name, :name

    def initialize(name, resource, options, action_name, request_params = {})
      @resource       = resource
      @options        = options
      @request_params = request_params
      @action_name    = action_name
      @name           = name

      raise ":path must be provided" unless @options.path

      sanitize_params
    end

    def sanitize_params
      @request_params = request_params.
        with_indifferent_access.
        reject do |k,v|
          ["action", "controller", "commit"].include?(k) || v.blank?
        end

      request_params[:order] ||= default_order
      request_params[:asc]   ||= default_asc
    end

    def default_order
      options.default_order.to_s
    end

    def default_asc
      options.default_direction == :asc ? "true" : "false"
    end

    def filter_params
      (request_params[:filters] || {}).with_indifferent_access
    end

    def filtered_resource
      return_scope = resource

      (options.filters || {}).each_pair do |scope_name, args|
        if args.is_a?(Array)
          args = args.map {|a| filter_params[a] }

          return_scope = return_scope.send(scope_name, *args)
        else
          return_scope = return_scope.instance_exec filter_params, &args
        end
      end

      return_scope
    end

    def output
      # Paginator.new(filtered_resource.order(get_order), get_page).call
      filtered_resource.order(get_order).page(get_page)
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
      order = request_params[:order]

      if order.blank?
        nil
      else
        convert_mapping(options.ordering[order.to_sym])
      end
    end

    def get_direction
      request_params[:asc] != "true" ? "DESC" : "ASC"
    end

    def convert_mapping(mapping)
      # Check if mapping was provided
      raise "No order mapping specified for '#{order}'" if mapping.blank?
      # Convert to array in order to simplify processing
      mapping = [mapping] if mapping.is_a?(String)
      # Convert to SQL form
      mapping.map {|m| "#{m} #{get_direction}"}.join(", ")
    end
  end
end
