require 'rails/generators'
require 'rbconfig'

class AdminBitsGenerator < Rails::Generators::Base
  include AdminBits::GeneratorHelpers

  argument :resource,
    :type => :string,
    :required => true,
    :desc => "Name of the resource eg. 'products' will create 'namespace/products_controller.rb'"

  class_option :layout,
    :type => :string,
    :desc => "Name of the generated layout eg. 'admin' will be placed in 'app/views/layouts/admin.html.erb'",
    :aliases => '-L', :default => 'admin'
  class_option :namespace,
    :type => :string,
    :desc => "Name of the namespace for the generated controller eg. 'admin'",
    :aliases => '-NS', :default => 'admin'
  class_option :unify,
    :type => :boolean,
    :default => true,
    :desc => "Create special BaseController in the selected namespace",
    :aliases => '-U'
  class_option :routing,
    :type => :boolean,
    :default => true,
    :desc => "Add routing based on resource and namespace",
    :aliases => '-AR'
  class_option :class_name,
    :type => :string,
    :desc => "Name of raw resource class",
    :aliases => '-CN'

  self.source_paths << File.join(File.dirname(__FILE__), 'templates')

  def create_controller
    template "controller.rb.erb", "app/controllers/#{ namespace }/#{ controller_name }.rb"
  end

  def create_resource
    template "resource.rb.erb", "lib/#{ namespace }/#{ resource_name }.rb"
  end

  def create_base_controller
    if options[:unify]
      template "base_controller.rb.erb", "app/controllers/#{ namespace }/base_controller.rb"
    end
  end

  def add_routing
    if options[:routing]
      route("namespace :#{namespace} do \n    resources :#{resource} \n  end")
    end
  end

  def create_views
    return unless options[:layout]

    params = { 'resource' => resource }
    params.merge!(options)

    unless AdminBits::Extentions.try(:call_generator, params)
      add_templates
      add_assets
    end
  end

  def add_config
    copy_file 'config.rb', 'config/initializers/admin_bits.rb'
  end

  protected

  def add_templates
    copy_file 'views/layout.html.erb', 'app/views/layouts/admin_bits/layout.html.erb'
    copy_file 'views/messages.html.erb', 'app/views/layouts/admin_bits/_messages.html.erb'
    template 'views/index.html.erb', "app/views/#{namespace}/#{resource}/index.html.erb"
    template 'views/new.html.erb', "app/views/#{namespace}/#{resource}/new.html.erb"
    template 'views/edit.html.erb', "app/views/#{namespace}/#{resource}/edit.html.erb"
    template 'views/form.html.erb', "app/views/#{namespace}/#{resource}/_form.html.erb"
  end

  def add_assets
    copy_file 'assets/stylesheets/admin_bits.css', 'app/assets/stylesheets/admin_bits.css'
    copy_file 'assets/javascripts/admin_bits.js', 'app/assets/javascripts/admin_bits.js'
    directory 'assets/images', 'app/assets/images/admin_bits'
  end
end
