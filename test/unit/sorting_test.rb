require 'test_helper'

class SortingTest < ActiveSupport::TestCase

  def create_class_with_admin_bits(&block)
    c = Class.new(ActionController::Base) do
      include AdminBits

      declare_resource :items, &block

      # Stub
      def params
        @params ||= {}
      end
    end
    c.new
  end

  test "there should be no default order specified, but it should still work" do
    c = create_class_with_admin_bits do
      path "/"
    end
    resource = c.admin_resource

    assert_equal resource.get_order, nil
  end

  test "one can set order column & direction other than default" do
    c = create_class_with_admin_bits do
      ordering :name => "items.name"
      path "/"
      default_order :name
    end
    resource = c.admin_resource

    assert_equal resource.get_order, "items.name DESC"
  end

  test "one can sort using multiple columns" do
    c = create_class_with_admin_bits do
      ordering :name => ["items.name", "items.id"]
      path "/"
      default_order :name
    end
    resource = c.admin_resource

    assert_equal resource.get_order, "items.name DESC, items.id DESC"
  end
end
