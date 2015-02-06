require 'rails/generators'
require 'rbconfig'

class AdminBitsGenerator < Rails::Generators::Base
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
      binding.pry
      add_assets_initializer
      add_templates
    end
  end

  protected

  def add_templates
    template "layout.html.erb", "app/views/layouts/admin_bits/layout.html.erb"
    template 'stylesheets.css', 'app/assets/stylesheets/admin_bits.css'
    template "index.html.erb", "app/views/#{namespace}/#{resource}/index.html.erb"
  end

  def add_assets_initializer
    unless Rails.application.config.assets.precompile.include?('admin_bits.css')
      content = 'Rails.application.config.assets.precompile += %w( admin_bits.css )'
      path = 'config/initializers/assets.rb'

      File.write(path, content, mode: 'a')
    end
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

  def permit_attributes
    names = all_attributes - ['id', 'created_at', 'updated_at']
    names.map(&:to_sym).to_s[1..-2]
  end

  def all_attributes
    raw_resource = eval(resource.singularize.camelcase)
    if raw_resource.class == Class
      raw_resource.attribute_names
    else
      []
    end
  end
end
