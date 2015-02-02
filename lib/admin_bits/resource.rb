module AdminBits
  class Resource
    include AdminBits
    include DefaultResourceMethods

    attr_reader :ordering_methods, :filter_methods

    def initialize(params)
      include_sorting_class
      @params = params
      determine_ordering_methods
      @filter_methods = self.class.filter_methods
    end

    def fetch_for_index
      params_handler.output
    end

    def filter_params
      params_handler.filter_params
    end

    def default_order
      class_order = self.class.default_order
      { method: class_order.first, direction: class_order.last }
    end

    def include_sorting_class
      if resource_class.ancestors.include? ActiveRecord::Base
        self.class.send :include, ActiveRecordSort
      else
        self.class.send :include, PlainSort
      end
    end

    def resource_class
      resource.class == Class ? resource : resource.class
    end

    def determine_ordering_methods
      @ordering_methods = self.class.ordering_methods.dup
      if @ordering_methods.include? :by_each_attribute
        @ordering_methods += by_each_attribute
        @ordering_methods.delete :by_each_attribute
      end
    end

    class << self
      def filters(*args)
        @filter_methods = args
      end

      def ordering(*args)
        @ordering_methods = []
        args.each do |arg|
          @ordering_methods << arg if arg.is_a?(Symbol)
          if arg.is_a?(Hash)
            @default_order = arg[:default].first
          end
        end
      end

      def filter_methods
        @filter_methods || []
      end

      def ordering_methods
        @ordering_methods || []
      end

      def default_order
        @default_order || []
      end
    end

    def resource_name
      resource.to_s.pluralize
    end

    def params_handler
      @params_handler ||= ParamsHandler.new(self, params)
    end
  end
end
