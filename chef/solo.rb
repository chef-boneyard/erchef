chef_repo_dir = File.dirname(File.expand_path(__FILE__))

file_cache_path File.join(chef_repo_dir, '.cache')
cache_type 'BasicFile'
cache_options(:path => File.join(chef_repo_dir, '.cache', 'checksums'))
cookbook_path File.join(chef_repo_dir, 'cookbooks')
