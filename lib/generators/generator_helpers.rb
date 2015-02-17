module AdminBits
  module GeneratorHelpers
    def resources_path
      "#{namespace}_#{resource}_path"
    end

    def resource_path
      "#{namespace}_#{resource.singularize}_path"
    end

    def namespace
      options[:namespace]
    end

    def resource_name
      (resource.singularize + '_resource')
    end

    def controller_name
      (resource + '_controller')
    end

    def attribute_names
      names = all_attributes
      names.delete_if do |attribute|
        attribute[-3..-1] == '_id'
      end
    end

    def permit_attributes_string
      permit_attributes.map(&:to_sym).to_s[1..-2]
    end

    def permit_attributes
      all_attributes - ['id', 'created_at', 'updated_at']
    end

    def all_attributes
      if raw_resource.class == Class
        raw_resource.attribute_names
      else
        []
      end
    end

    def raw_resource
      klass.constantize
    end

    def klass
      options[:class_name] || resource.singularize.camelcase
    end
  end
end
