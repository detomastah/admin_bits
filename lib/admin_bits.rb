module AdminBits
  class Engine < ::Rails::Engine
  end

  autoload :BaseConfig,     'admin_bits/base_config'
  autoload :Helpers,        'admin_bits/helpers'
  autoload :AdminResource,  'admin_bits/admin_resource'

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def declare_resource(name, options = {}, &block)
      raise "Name must be Symbol" unless name.is_a?(Symbol)

      ab_config = AdminBits::BaseConfig.new
      ab_config.instance_eval &block

      helper_method name
      helper Helpers
      helper_method :admin_resource
      helper_method :admin_filter

      define_method :admin_resource do
        AdminResource.new(
          raw_resource,
          ab_config,
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


      # Set layout, use default if not specified
      if ab_config.get_layout.nil? || ab_config.get_layout == :default
        layout "admin_bits"
      elsif ab_config.get_layout != :off
        layout ab_config.get_layout
      end

      private :admin_resource
      private :raw_resource
    end
  end
end
