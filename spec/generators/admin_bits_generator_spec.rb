require 'spec_helper'

require 'generators/admin_bits_generator'

describe AdminBitsGenerator do
  destination File.expand_path('../../../../../tmp/tests', __FILE__)

  before { prepare_destination }

  describe 'the generated files' do

    before { run_generator %w(items --skip-routing)  }

    describe 'resource class' do
      subject { file("app/models/admin/item_resource.rb") }

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
        expect(subject).to have_method :new
        expect(subject).to have_method :create
        expect(subject).to have_method :edit
        expect(subject).to have_method :update
        expect(subject).to have_method :destroy
        expect(subject).to have_method :resource
        expect(subject).to have_method :item_params
      end
    end

    describe 'views' do
      describe 'layout' do
        subject { file('app/views/layouts/admin_bits/layout.html.erb') }

        it 'exist' do
          expect(subject).to exist
        end

        it 'has correct syntax' do
          expect(subject).to have_correct_syntax
        end

        it 'has proper content' do
          expect(subject).to contain '<%= yield %>'
        end
      end

      describe 'index' do
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
          expect(subject).to contain '<%= paginate @items %>'
        end
      end

      describe 'form' do
        subject { file('app/views/admin/items/_form.html.erb') }

        it 'exist' do
          expect(subject).to exist
        end

        it 'has correct syntax' do
          expect(subject).to have_correct_syntax
        end

        it 'has proper content' do
          expect(subject).to contain '<%= f.label :name %>'
          expect(subject).to contain '<%= f.label :price %>'
          expect(subject).to contain '<%= f.label :description %>'

          expect(subject).to contain '<%= f.text_field :name %>'
          expect(subject).to contain '<%= f.text_field :price %>'
          expect(subject).to contain '<%= f.text_field :description %>'
          expect(subject).to contain "<%= f.submit class: 'button success', id: 'submit' %>"
        end
      end

      describe 'new' do
        subject { file('app/views/admin/items/new.html.erb') }

        it 'exist' do
          expect(subject).to exist
        end

        it 'has correct syntax' do
          expect(subject).to have_correct_syntax
        end

        it 'has proper content' do
          expect(subject).to contain '<h2>New Item</h2>'
          expect(subject).to contain "<%= render 'form' %>"
        end
      end

      describe 'edit' do
        subject { file('app/views/admin/items/edit.html.erb') }

        it 'exist' do
          expect(subject).to exist
        end

        it 'has correct syntax' do
          expect(subject).to have_correct_syntax
        end

        it 'has proper content' do
          expect(subject).to contain '<h2>Edit Item</h2>'
          expect(subject).to contain "<%= render 'form' %>"
        end
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

  describe 'extentions' do
    before do
      allow(AdminBits::Extentions).to receive(:call_generator).and_return(true)
      run_generator %w(items --skip-routing)
    end

    it "doesn't create view files" do
      expect(file('app/views/admin/items/index.html.erb')).to_not exist
      expect(file('app/views/admin/items/_form.html.erb')).to_not exist
      expect(file('app/views/admin/items/new.html.erb')).to_not exist
      expect(file('app/views/admin/items/edit.html.erb')).to_not exist
      expect(file('app/assets/stylesheets/admin_bits.css')).to_not exist
    end
  end
end
