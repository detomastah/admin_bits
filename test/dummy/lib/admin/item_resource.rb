 class Admin::ItemResource
  include AdminBits

  declare_resource :items

  def path
    admin_items_path
  end

  def filters
    {
      # Points to Item#having_name, passes params[:filters][:name] as the only param
      having_name: [:name],
      # One can define own filter criteria of arbitrary name using lambdas
      price_between: lambda { |f|
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
