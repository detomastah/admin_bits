class BasicAdminPanel
  def initialize(controller_class, options = {})
    controller_class.instance_eval do
      layout "admin_bits_modules/basic_admin_panel/layout"

      def columns_for_index(*columns)
        @columns_for_index = columns
      end

      def redefine_action(action)
        unless instance_variable_get("@#{action}_defined")
          alias_method :"original_#{action}", action
          remove_method action
          instance_variable_set("@#{action}_defined", true)

          define_method action do
            send(:"original_#{action}")
            begin
              render "admin_bits_modules/basic_admin_panel/#{action}"
            rescue AbstractController::DoubleRenderError
              # Do nothing - render view specified by user
            end
          end
        end
      end

      def redefine_update_action
        action = :update
        unless instance_variable_get("@#{action}_defined")
          alias_method :"original_#{action}", action
          remove_method action
          instance_variable_set("@#{action}_defined", true)

          define_method action do
            resource = admin_resource.name.to_s.singularize
            send(:"original_#{action}")
            ivar = instance_variable_get("@#{resource}")
            ivar.attributes = params[resource]
            begin
              if ivar.save
                redirect_to :action => :index
              else
                render "admin_bits_modules/basic_admin_panel/edit"
              end
            rescue AbstractController::DoubleRenderError
              # Do nothing - render view specified by user
            end
          end
        end
      end

      def method_added(method_name)
        case method_name
        when :index, :edit, :show
          redefine_action method_name
        when :update
          redefine_update_action
        end
      end
    end

  end


end
