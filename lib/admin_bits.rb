module AdminBits
  autoload :DefaultResourceMethods,  'admin_bits/default_resource_methods'
  autoload :Resource,                'admin_bits/resource'
  autoload :BaseConfig,              'admin_bits/base_config'
  autoload :Helpers,                 'admin_bits/helpers'
  autoload :ParamsHandler,           'admin_bits/params_handler'
  autoload :PathHandler,             'admin_bits/params_handler/path_handler'
  autoload :ActiveRecordSort,        'admin_bits/sorting/active_record_sort'
  autoload :PlainSort,               'admin_bits/sorting/plain_sort'
  autoload :Controller,              'admin_bits/controller'


  def self.included(base)
    base.extend(ClassMethods)
    base.send :attr_reader, :params
    base.send :include, Rails.application.routes.url_helpers
  end

  module ClassMethods
    def declare_resource

      ActionView::Base.send :include, Helpers

      define_method :params_handler do
        ParamsHandler.new(self, params)
      end

      define_method :admin_filter do |name|
        params_handler.filter_params[name]
      end
    end
  end
end
