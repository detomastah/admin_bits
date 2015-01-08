module AdminBits
  module ActiveRecordScopes

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def admin_extension_scopes
        @@admin_extension_scopes || {}
      end

      def declare_time_range_scope(name, options = {})
        @@admin_extension_scopes ||= {}
        @@admin_extension_scopes[name] = :time_range

        define_method name do |date_from, date_to|
          column = options.fetch(:on)
          date_from = Time.parse(date_from) rescue nil
          date_to   = Time.parse(date_to) rescue nil

          result_scope = current_resource
          if date_from
            result_scope = result_scope.where("#{column} >= ?",  date_from)
          end

          if date_to
            result_scope = result_scope.where("#{column} <= ?",  date_to)
          end
          @filtered_resource = result_scope
          self
        end
      end

      def declare_text_search_scope(name, options = {})
        @@admin_extension_scopes ||= {}
        @@admin_extension_scopes[name] = :text

        define_method name do |text|
          result_scope = current_resource

          if text.present?
            columns = options.fetch(:on)
            @filtered_resource = result_scope.where(AdminExtension::Utils.create_search_conditions(text, columns))
          end
          self
        end
      end
    end

  end
end
