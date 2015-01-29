require 'spec_helper'

require 'generators/admin_bits_generator'

describe AdminBitsGenerator do
  destination File.expand_path('../../../../../tmp/tests', __FILE__)

  before { prepare_destination }

  describe 'the generated files' do

    before { run_generator %w(--resource items --add_routing false)  }

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
        expect(subject).to contain /helper_method :admin_resource, :admin_filter/
        expect(subject).to have_method :admin_resource
        expect(subject).to have_method :admin_filter
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
  end

  describe 'routes' do
    subject { file('config/routes.rb') }

    before do
      routes = Rails.root + 'config/routes.rb'
      destination = File.join(destination_root, 'config')
      FileUtils.mkdir_p(destination)
      FileUtils.cp routes, destination
      run_generator %w(--resource objects)
    end

    it 'has correct syntax' do
      expect(subject).to have_correct_syntax
    end

    it 'has correct syntax' do
      expect(subject).to contain('resources :objects, namespace: :admin')
    end
  end
end
