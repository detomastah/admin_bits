admin_bits
==========

[![Build Status](https://travis-ci.org/bitmincer/admin_bits.svg)](https://travis-ci.org/bitmincer/admin_bits)

AdminBits simplifies creation of sortable / searchable lists found in dashboards / admin panels.

## Installation

Add the following line to your Gemfile:

`gem 'admin_bits', '~> 0.4.0'`

## Usage

### Getting Started
We recommend to use admin_bits generator.
```rails generate admin_bits [options]```

option | description
------ | ---------
-R, --resource=RESOURCE | Name of the resource eg. 'products'
-NS, --namespace=NAMESPACE | Name of the namespace for the generated controller eg. 'admin' <br> Default: admin
-U, --unify, --no-unify | Create special BaseController in the selected namespace <br> Default: true
-L, --layout=LAYOUT | Name of the generated layout eg. 'admin' will be placed in 'app/views/layouts/admin.html.erb' <br> Default: admin

This generator will create  controller for specified resource, class which contain settings related with resource placed in `lib/namespace` and layout. Depending on the options it can also create BaseController. If you want to use our helpers you have to generate this BaseController.

### Resource class

#### Basic overview

This class will contain settings associated with the particular resource.
It must inherit from `AdminBits::Resource`
Resource class must contain `resource` method which return ActiveRecord resource and `path` method which return path to this resource.
Example for Item resource.
```ruby
def resource
  Item
end

def path
  admin_items_path
end
```

To use this class in your controller you have to create new instance of it and pass params as argument. Then you can use `fetch_for_index` method. It will fetch all elements that satisfies the conditions passed in params.
```ruby
@item_resource = Admin::ItemResource.new(params)
@items = @item_resource.fetch_for_index
```

#### Filters

You can use filters by execute `filters` class method in your Resource class and pass to it as symbols names of your filter methods. Those filter methods must receive resource and return this resource after filtering. In these methods you have access to prams passed to Resource class through filter_params variable.
In this example we assume that you have `having_name` method in your model.
```ruby
filters :having_name

def having_name(resource)
  resource.having_name(filter_params[:name])
end
```
Remember that Resource class execute each filter methods passed to `filters` class method, so you have to return proper resource from each of these methods.

#### Ordering

To fetch elements in defined order you have to execute `ordering` class method in your Resource class and pass to it as symbols names of your ordering methods. Those ordering methods must receive resource and return this resource after ordering. Second parameter to those methods is direction.
To select proper ordering method you have to pass `"order"=>"method_name"` in params. ASC direction is determined by `"asc"=>"true"` in params.
You can determine default order in last parameter to `ordering` class method.

```ruby
ordering :by_name, default: { by_price: :asc }

def by_name(resource, direction = :asc)
  resource.order("name #{direction}")
end
```
 ###### ActiveRecord
 If your resource inherits form ActiveRecord you can use `by_each_attribute` ordering option. This option will generate by_attribute_name sorting method for each attribute of resource, you can use those methods like other self-defined ordering methods. You can also overwrite some of them.
```ruby
ordering :by_each_attribute
```
###### Plain resource
If your resource is Array you can use `plain` ordering option. This allows you to use `plain` ordering method like other ordering methods. If your resource is Array this method will sort your Array. If you pass `:desc` as second argument your resource will be sort descending.
```ruby
ordering :plain
```
#### Pagination
You can paginate your resources. To do this you have to pass page number in `params[:page]` You can customize "per_page" value in Resource class
```ruby
def per_page
  30
end
```

## Credits

admin_bits is maintained and funded by bitmincer. Thank you
to all the [contributors][contributors].

## License

admin_bits is copyright © 2013-2014 bitmincer. It is free software,
and may be redistributed under the terms specified in the
[LICENSE](LICENSE) file.

[contributors]: https://github.com/bitmincer/admin_bits/contributors
