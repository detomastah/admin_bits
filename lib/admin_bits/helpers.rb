module AdminBits
  module Helpers

    def admin_link(attrib, name)
      link_content = name.html_safe
      if params_handler.request_params[:order] == attrib.to_s
        ascending = params_handler.request_params[:asc] == "true" ? true : false
        klass = ascending ? "sort_asc" : "sort_desc"
        ascending = !ascending
      else
        klass = nil
        ascending = true
      end

      link_to link_content, params_handler.url(:order => attrib, :asc => ascending.to_s), :class => klass
    end

    def admin_form(options = {}, &block)
      form_tag(params_handler.original_url, options) do
        content = capture(&block)

        tags = [
          hidden_field_tag("order", params_handler.request_params[:order]),
          hidden_field_tag("asc", params_handler.request_params[:asc]),
          content
        ]

        tags.join("").html_safe
      end
    end

    def admin_select_filter(attribute, options, html_options)
      select_tag "filters[#{attribute}]", options, html_options
    end

    def admin_text_filter(attribute)
      text_field_tag "filters[#{attribute}]", params_handler.filter_params[attribute], class: 'form-control'
    end

    def admin_date_filter(attribute)
      text_field_tag "filters[#{attribute}]", params_handler.filter_params[attribute], :class => "datepicker"
    end

    def current_resource
      resource.resource_name
    end
  end
end
