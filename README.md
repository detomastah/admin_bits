AdminBits
==========

[![Build Status](https://travis-ci.org/bitmincer/admin_bits.svg)](https://travis-ci.org/bitmincer/admin_bits)

AdminBits simplifies creation of sortable / searchable lists found in dashboards / admin panels.

## Information

* RDoc documentation [available on RubyDoc.info](http://rubydoc.info/gems/admin_bits)
* Source code [available on GitHub](https://github.com/bitmincer/admin_bits)
* More information, known limitations, and how-tos [available on the wiki](https://github.com/bitmincer/admin_bits/wiki)
* [live demo](http://demo-admin-bits.herokuapp.com/admin)
## Getting Help

* Please report bugs on the [issue tracker](https://github.com/bitmincer/admin_bits/issues) but read the "getting help" section in the wiki first.

## Installation

Install the latest stable release:
```
  [sudo] gem install admin_bits
```

In Rails, add it to your Gemfile:

```ruby
gem 'admin_bits'
```

Finally, restart the server to apply the changes.

## Getting Started
We recommend to use admin_bits generator.
```
  rails generate admin_bits items [options]
```

this should add route `admin/items` and give you files:
```
  lib/admin/item_resource.rb
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

admin_bits is maintained and funded by bitmincer. Thank you
to all the [contributors][contributors].

## License

admin_bits is copyright © 2013-2014 bitmincer. It is free software,
and may be redistributed under the terms specified in the
[LICENSE](LICENSE) file.

[contributors]: https://github.com/bitmincer/admin_bits/contributors
