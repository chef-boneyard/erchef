repos = {
  'chef_authn' => 'chef_authn',
  'chef_certgen' => 'chef_certgen',
  'chef_db' => 'chef_db',
  'chef_index' => 'chef_index',
  'chef_objects' => 'chef_objects',
  'chef_wm' => 'chef_wm',
  'depsolver' => 'depsolver',
  'fast_log' => 'fast-log-erlang',
  'stats_hero' => 'stats_hero',
  'omnibus-chef-server' => 'omnibus-chef-server'
}

remote = node['dev']['setup']['git-remote']
read_only = node['dev']['setup']['read_only_repos']
make_git_url = Proc.new do |repo|
    prefix = if read_only
               "git://github.com"
             else
               "git@github.com:"
             end
    [prefix, remote, repo].join('/')
end

repos.each do |repo, github_name|
  execute "clone #{repo}" do
    cwd DevHelper.parent_dir
    command "git clone #{make_git_url.call(github_name)} #{repo}"
    not_if "test -d #{DevHelper.parent_dir}/#{repo}"
  end
end
