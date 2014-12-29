module AdminBits
  class BaseConfig
    def initialize
      @options = {}.with_indifferent_access
    end

    def [](name)
      @options.send name
    end

    def self.rw_method(name)
      define_method name do |value = nil, &block|
        throw_error if block && value
        @options[name] = value || block
      end

      define_method "get_#{name}" do
        @options[name]
      end
    end

    def inspect
      @options.inspect
    end

    rw_method :path
    rw_method :filters
    rw_method :ordering
    rw_method :default_order
    rw_method :default_direction
    rw_method :layout # :off | :default | "layout_name"
    rw_method :mods # [BasicAdminPanel]
  private
    def throw_error
      raise "Please provide either block of value"
    end
  end
end
