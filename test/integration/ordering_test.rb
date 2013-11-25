require 'test_helper'

class OrderingTest < ActiveSupport::IntegrationCase
  test "I can see default DESC order on PRICE" do
    visit admin_items_path
    find(:css, "a.sort_desc", :text => "Total price")
  end

  test "I can easily change order" do
    visit admin_items_path
    click_link("Total price")
    find(:css, "a.sort_asc", :text => "Total price")
  end
end
