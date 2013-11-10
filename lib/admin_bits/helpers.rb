module AdminBits
  module Helpers
    def admin_header(attrib, name)
      link_content = name.html_safe

      if admin_resource.request_params[:order] == attrib.to_s
        ascending = admin_resource.request_params[:asc] == "true" ? true : false
        klass = ascending ? "sort_asc" : "sort_desc"
        ascending = !ascending
      else
        klass = nil
        ascending = true
      end

      content_tag :th, :class => "sort" do
        link_to link_content, admin_resource.url(:order => attrib, :asc => ascending), :class => klass
      end
    end

    def admin_form
    end
  end
end
