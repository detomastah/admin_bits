module AdminBits
  autoload :Resource,       'admin_bits/resource'
  autoload :BaseConfig,     'admin_bits/base_config'
  autoload :Helpers,        'admin_bits/helpers'
  autoload :AdminResource,  'admin_bits/admin_resource'
  autoload :PathHandler,    'admin_bits/admin_resource/path_handler'
  include Resource


  def self.included(base)
    base.extend(ClassMethods)
    base.send :attr_reader, :params
    base.send :include, Rails.application.routes.url_helpers
  end

  module ClassMethods
    def declare_resource(name)
      raise "Name must be Symbol" unless name.is_a?(Symbol)

      ActionView::Base.send :include, Helpers

      define_method :admin_resource do
        AdminResource.new(
          name,
          raw_resource,
          self,
          params
        )
      end

      define_method :raw_resource do
        eval name.to_s.capitalize.singularize
      end

      define_method :admin_filter do |name|
        admin_resource.filter_params[name]
      end

      define_method name do
        admin_resource.output
      end
    end
  end
end
