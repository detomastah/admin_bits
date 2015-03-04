AdminBits
==========

[![Build Status](https://travis-ci.org/detomastah/admin_bits.svg)](https://travis-ci.org/detomastah/admin_bits)

AdminBits simplifies creation of sortable & searchable lists found in various dashboards (like admin sections, search forms etc).

## Information

* RDoc documentation [available on RubyDoc.info](http://rubydoc.info/gems/admin_bits)
* Source code [available on GitHub](https://github.com/bitmincer/admin_bits)
* More information, known limitations, and how-tos [available on the wiki](https://github.com/bitmincer/admin_bits/wiki)
* [Live demo](http://demo-admin-bits.herokuapp.com/admin)

## Getting Help

* Please report bugs on the [issue tracker](https://github.com/bitmincer/admin_bits/issues) but read the "getting help" section in the wiki first.

## Installation

Install the latest stable release:
```
  gem install admin_bits
```

In Rails, add it to your Gemfile:

```ruby
gem 'admin_bits'
```

Finally, restart the server to apply the changes.

## Getting Started
The easiest way to get started is to user admin_bits generator.

Let's assume that you have model `Item`. The following command will create a new `Admin::ItemsController` with initial resource:

```
  rails generate admin_bits items
```

The resource, layout and assets can be freely modified. If there were no errors, one should be able to see new route `admin/items`.

Some new files should have appeared, like:
```
  app/models/admin/item_resource.rb
  app/controllers/admin/base_controller.rb
  app/controllers/admin/items_controller.rb
  app/views/layouts/admin.html.erb
```

If you want to learn more about the generator check its [documentation](https://github.com/wilqq/admin_bits/wiki/Generator).

Check out your `item_resource` class for some hints on how you can customize your Resource. This class contain settings associated with the items resource. You can also check [documentation](https://github.com/wilqq/admin_bits/wiki/Resource-class) for more information.

You will find `resource` private method in resource items_controller.

```ruby
def resource
  @resource ||= Admin::ItemResource.new(params)
end
```

You can use this for example in your index action:

```ruby
def index
  @items = resource.fetch_for_index
end
```


## Credits

admin_bits is maintained and funded by bitmincer & detomastah. Thank you
to all the [contributors][contributors].

## License

admin_bits is copyright © 2013-2015 bitmincer. It is free software,
and may be redistributed under the terms specified in the
[LICENSE](LICENSE) file.

[contributors]: https://github.com/bitmincer/admin_bits/contributors
