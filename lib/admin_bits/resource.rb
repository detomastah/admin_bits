module AdminBits
  class Resource
    include AdminBits
    include DefaultResourceMethods

    attr_reader :default_order, :ordering_methods

    def initialize(params)
      @params = params
      self.class.declare_resource resource
      @ordering_methods = self.class.ordering_methods
      @default_order = self.class.default_order
    end

    def fetch_for_index
      admin_resource.output
    end

    def filter_params
      admin_resource.filter_params
    end


    class << self
      def filters(*args)

      end

      def ordering(*args)
        @@ordering_methods = []
        args.each do |arg|
          @@ordering_methods << arg if arg.is_a?(Symbol)
          if arg.is_a?(Hash)
            @@default_order = arg[:default]
          end
        end
      end

      def ordering_methods
        @@ordering_methods
      end

      def default_order
        @@default_order
      end
    end
  end
end
