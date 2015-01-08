module AdminBits
  module Scopes

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

        scope name, ->(date_from, date_to) do
          column = options.fetch(:on)
          date_from = Time.parse(date_from) rescue nil
          date_to   = Time.parse(date_to) rescue nil

          result_scope = where(nil)

          if date_from
            result_scope = result_scope.where(arel_table[column].gteq(date_from))
          end

          if date_to
            result_scope = result_scope.where(arel_table[column].lteq(date_to))
          end

          result_scope
        end
      end

      def declare_text_search_scope(name, options = {})
        @@admin_extension_scopes ||= {}
        @@admin_extension_scopes[name] = :text

        scope name, ->(text) do
          if text.present?
            columns = options.fetch(:on)
            where(AdminExtension::Utils.create_search_conditions(text, columns))
          else
            where(nil)
          end
        end
      end
    end

  end
end
