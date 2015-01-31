module AdminBits
  module Controller
    def self.included(base)
      base.send :helper_method, :params_handler, :admin_filter, :resource
      base.send :delegate, :params_handler, to: :resource
      base.send :helper, AdminBits::Helpers
    end

    def admin_filter(*args)
      result = resource.filter_params
      args.each do |arg|
        result = result.try(:fetch, arg, nil)
      end
      result
    end
  end
end
