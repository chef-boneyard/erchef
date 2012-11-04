repos = %w(chef_authn
           chef_certgen
           chef_db
           chef_index
           chef_objects
           chef_wm
           depsolver
           fast_log
           stats_hero)

remote = node['dev']['setup']['git-remote']
read_only = node['dev']['setup']['read_only_repos']
make_git_url = Proc.new do |repo|
    prefix = if read_only
               "git://github.com/"
             else
               "git@github.com:"
             end
    [prefix, remote, repo].join('/')
end

repos.each do |repo|
  execute "clone #{repo}" do
    cwd DevHelper.parent_dir
    command "git clone #{make_git_url.call(repo)}"
    not_if "test -d #{DevHelper.parent_dir}/#{repo}"
  end
end

