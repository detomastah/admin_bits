# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "admin_bits"
  s.summary = "AdminBits is a toolbox for custom dashboards "
  s.description = "AdminBits simplifies creation of sortable / searchable lists found in dashboards / admin panels"
  s.files = Dir["{app,lib,test,spec}/**/*"] + ["LICENSE", "Rakefile", "Gemfile", "README.md"]
  s.version = "0.4.0"
  s.add_dependency 'kaminari', '~> 0.16.1'
  s.add_dependency 'railties', "~>4.0"
  s.date  = '2014-12-19'
  s.email = "lpelszyn@o2.pl"
  s.authors = ["Lukasz Pelszynski"]
  s.homepage = "https://github.com/bitmincer/admin_bits"
  s.add_development_dependency 'rake'
  s.add_development_dependency "rspec"
  s.require_path = 'lib'
end
