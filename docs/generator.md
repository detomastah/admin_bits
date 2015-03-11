## Generator

	rails generate admin_bits resources [options]


option | description
------ | ---------
resource | Name of the resource eg. 'products'
--skip-unify | Skip creation special BaseController in the selected namespace
--skip-routing | Skip add routing based on resource and namespace
-NS, --namespace=NAMESPACE | Name of the namespace for the generated controller eg. 'admin' <br> Default: admin
-L, --layout=LAYOUT | Name of the generated layout eg. 'admin' will be placed in 'app/views/layouts/admin.html.erb' <br> Default: admin
-CN, --class-name=CLASS_NAME | Name of raw resource class

This generator will create  controller for specified resource, class which contain settings related with resource placed in `lib/namespace` and layout. Depending on the options it can also create BaseController. If you want to use our helpers you have to generate this BaseController.
