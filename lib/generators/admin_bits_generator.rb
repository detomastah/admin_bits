require 'rails/generators'
require 'rbconfig'

class AdminBitsGenerator < Rails::Generators::Base

  class_option :layout,
    :type => :string,
    :desc => "Name of the generated layout eg. 'admin' will be placed in 'app/views/layouts/admin.html.erb'",
    :aliases => '-L', :default => 'admin'
  class_option :namespace,
    :type => :string,
    :desc => "Name of the namespace for the generated controller eg. 'admin'",
    :aliases => '-NS', :default => 'admin'
  class_option :resource,
    :type => :string,
    :required => true,
    :desc => "Name of the resource eg. 'products' will create 'namespace/products_controller.rb'",
    :aliases => '-R'
  class_option :unify, # TODO
    :type => :boolean,
    :default => false,
    :desc => "Create special BaseController in the selected namespace",
    :aliases => '-U'

  self.source_paths << File.join(File.dirname(__FILE__), 'templates')

  def create_layout
    template "layout.html.erb", "app/views/layouts/#{ layout }.html.erb"
  end

  def create_controller
    template "controller.rb.erb", "app/controllers/#{ namespace }/#{ resource }_controller.rb"
  end

  protected

  def layout
    options[:layout]
  end

  def namespace
    options[:namespace]
  end

  def resource
    options[:resource]
  end

  def controller_name
    (resource + '_controller')
  end
end
