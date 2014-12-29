 class Admin::ItemResource
  include AdminBits
  include Rails.application.routes.url_helpers

  # will be moved to another class
  ###########################################

  def initialize(controller, params)
    @params = params
    @items = Item
    @controller = controller
    class_eval { declare_resource :item, controller }
  end

  def fetch_for_index
    admin_resource.output
  end

  def filter_params
    admin_resource.filter_params
  end

  def admin_resource
    @admin_resource ||= AdminResource.new(
      :item,
      Item,
      self,
      'action_name',
      @params
    )
  end

  ########################################################

  def path
    admin_items_path
  end

  def filters
    {
      # Points to Item#having_name, passes params[:filters][:name] as the only param
      :having_name => [:name],
      # One can define own filter criteria of arbitrary name using lambdas
      :price_between => lambda { |f|
        from = f[:from].present? ? f[:from].to_i : nil
        to   = f[:to].present? ? f[:to].to_i : nil

        ret = where(nil)
        ret = ret.where(["price <= ?", to]) if to
        ret = ret.where(["price >= ?", from]) if from
        ret
      }
    }
  end

  def having_name(filter_params)
    resource_class.having_name(filter_params[:name])
  end

  def price_between(filter_params)
    # ...
  end

  def ordering
    {
      name: "items.name",
      price: "items.price"
    }
  end

  def default_order
    :price
  end

  def default_direction
    :desc
  end
end
