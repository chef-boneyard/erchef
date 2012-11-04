# if you have write access to the repositories, create
# chef/dev_config.json based on the .example file and set this
# attribute to false.
default['dev']['setup']['read_only_repos'] = true

# You can use this if you've created forks of all of the repositories
# (see the setup.rb recipe for the list of repositories.)
default['dev']['setup']['git-remote'] = 'opscode'
