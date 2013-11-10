module AdminBits
  class Engine < ::Rails::Engine
  end

  autoload :Helpers,        'admin_bits/helpers'
  autoload :AdminResource,  'admin_bits/admin_resource'

  def self.included(base)
    base.extend(ClassMethods)
    base.helper_method :admin_resource
  end

  module ClassMethods
    def declare_resource(name, options = {})
      raise "Name must be Symbol" unless name.is_a?(Symbol)

      helper_method name
      helper Helpers

      define_method :admin_resource do
        AdminResource.new(
          raw_resource,
          options,
          action_name,
          params
        )
      end

      define_method :raw_resource do
        instance_variable_get("@#{name}")
      end

      define_method :admin_filter do |name|
        admin_resource.filter_params[name]
      end

      define_method name do
        admin_resource.output
      end

      private :admin_resource
      private name
      private :raw_resource
    end
  end
end
