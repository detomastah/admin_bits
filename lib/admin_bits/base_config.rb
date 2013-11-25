module AdminBits
  class BaseConfig
    def initialize
      @options = {}.with_indifferent_access
    end

    def [](name)
      @options[name]
    end

    def self.rw_method(name)
      define_method name do |option|
        @options[name] = option
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
  end

  def eval!
  end

end
