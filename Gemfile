source :rubygems

gem 'chef-pedant-core', :git => "git@github.com:opscode/chef-pedant-core.git"
gem 'chef-pedant-tests', :git => "git@github.com:opscode/chef-pedant-tests.git"

# If you want to load debugging tools into the bundle exec sandbox,
# # add these additional dependencies into Gemfile.local
eval(IO.read(__FILE__ + '.local'), binding) if File.exists?(__FILE__ + '.local')
