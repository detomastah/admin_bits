require 'spec_helper'

require 'generators/admin_bits_generator'

describe AdminBitsGenerator do
  destination File.expand_path('../../../../../tmp/tests', __FILE__)

  before { prepare_destination }

  describe 'the generated files' do

    before { run_generator %w(items --skip-routing)  }

    describe 'resource class' do
      subject { file("lib/admin/item_resource.rb") }

      it 'exist' do
        expect(subject).to exist
      end

      it 'has correct syntax' do
        expect(subject).to have_correct_syntax
      end

      it 'has proper method and content' do
        expect(subject).to contain /class Admin::ItemResource < AdminBits::Resource/
        expect(subject).to have_method :resource
        expect(subject).to have_method :path
      end
    end

    describe 'base controller' do
      subject { file("app/controllers/admin/base_controller.rb") }

      it 'exist' do
        expect(subject).to exist
      end

      it 'has correct syntax' do
        expect(subject).to have_correct_syntax
      end

      it 'has proper method and content' do
        expect(subject).to contain /class Admin::BaseController < ApplicationController/
        expect(subject).to contain /include AdminBits::Controller/
      end
    end

    describe 'resource controller' do
      subject { file("app/controllers/admin/items_controller.rb") }

      it 'exist' do
        expect(subject).to exist
      end

      it 'has correct syntax' do
        expect(subject).to have_correct_syntax
      end

      it 'has proper method and content' do
        expect(subject).to contain /class Admin::ItemsController < Admin::BaseController/
        expect(subject).to have_method :index
        expect(subject).to have_method :edit
        expect(subject).to have_method :update
        expect(subject).to have_method :resource
      end
    end

    describe 'layout' do
      subject { file('app/views/layouts/admin_bits/layout.html.erb') }

      it 'exist' do
        expect(subject).to exist
      end

      it 'has correct syntax' do
        expect(subject).to have_correct_syntax
      end

      it 'has proper content' do
        expect(subject).to contain '<%= current_resource %>'
        expect(subject).to contain '<%= yield %>'
      end
    end

    describe 'stylesheets' do
      subject { file('app/assets/stylesheets/admin_bits.css') }

      it 'exist' do
        expect(subject).to exist
      end
    end

    describe 'index view' do
      subject { file('app/views/admin/items/index.html.erb') }

      it 'exist' do
        expect(subject).to exist
      end

      it 'has correct syntax' do
        expect(subject).to have_correct_syntax
      end

      it 'has proper content' do
        expect(subject).to contain '<% @items.each do |obj| %>'
        expect(subject).to contain '<%= admin_link(:by_name, "name") %>'
      end
    end
  end

  describe 'routes' do
    subject { file('config/routes.rb') }

    before do
      routes = Rails.root + 'config/routes.rb'
      destination = File.join(destination_root, 'config')
      FileUtils.mkdir_p(destination)
      FileUtils.cp routes, destination
      run_generator %w(products)
    end

    it 'has correct syntax' do
      expect(subject).to have_correct_syntax
    end

    it 'has proper content' do
      expect(subject).to contain("namespace :admin do \n    resources :products \n  end")
    end
  end
end
