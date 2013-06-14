# Erchef: The Opscode Chef Server #

* Documentation: http://docs.opscode.com/
* Tickets/Issues: http://tickets.opscode.com
* IRC: [#chef](irc://irc.freenode.net/chef) and [#chef-hacking](irc://irc.freenode.net/chef-hacking) on Freenode
* Mailing list: http://lists.opscode.com

## Overview ##

## How to Build a deb package using omnibus-chef-server ##

You will need:

* [VirtualBox][]
* [Internet][] connection
* A checkout of
  [omnibus-chef-server](https://github.com/opscode/omnibus-chef-server) (comes along
  for the ride if you followed obtaining source repositories below).

[VirtualBox]: https://www.virtualbox.org/
[Internet]: http://en.wikipedia.org/wiki/Internet

1. Create an `omnibus.rb` config file:

   ```
   cd omnibus-chef-server
   cp omnibus.rb.example omnibus.rb
   # edit and set use_s3_caching to false
   ```

2. Install gem dependencies (assumes you already have a recent Ruby
   and bundler gem installed):

   ```
   bundle install --binstubs
   ```

3. Build a deb package:

   ```
   # list available package types
   bin/vagrant status

   # build a deb
   bin/vagrant omnibus build ubuntu-10.04 chef-server
   ```

   Wait patiently. The omnibus builder will download and compile 33.4% of
   one internet.

   The installer can be found in the `pkg` directory of your
   `omnibus-chef-server` checkout.

## How to Hack on Erchef ##

Before working on the code, if you plan to contribute your changes,
you need to read the [Opscode Contributing document][contrib].

[contrib]: http://wiki.opscode.com/display/chef/How+to+Contribute

### Required software ###

1. GNU Make
2. git
3. Ruby (rubygems and bundler are also needed)
4. Erlang R15B01 or greater

### Obtaining source repositories ###

1. Install a recent chef gem

   ```
   gem install chef --no-ri --no-rdoc
   ```

2. The `clone_for_dev` make target will use `chef-solo` to obtain git
   checkouts of relevant repositories. By default it will clone
   using the read-only git URL:

   ```
   mkdir chef-server
   cd chef-server
   git clone git@github.com:opscode/erchef.git
   cd erchef
   make clone_for_dev
   ```

   The repositories will be created as peers to the erchef directory.

### Building erchef ###

You can build the OTP release for Erchef as follows:

```
cd erchef
make rel
```

## Reporting Bugs ##

You can search for known issues in
[Opscode Chef's bug tracker][jira]. Tickets should be filed under the
**CHEF** project with the component set to **"Chef Server"**.

[jira]: http://tickets.opscode.com/browse/CHEF


## A tour of the erchef repositories ##

A picture is worth some words!

![erchef component diagram](https://raw.github.com/opscode/erchef/master/doc/erchef_components.png)


* `erchef`: The top-level erchef repository is used to build
  self-contained OTP releases of erchef. You can build a OTP release
  of erchef by running `make rel` in the erchef directory. This will
  download all dependencies, compile Erlang code, and put (almost)
  everything needed into `rel/erchef`. What isn't included?
  Configuration for erchef is handled by omnibus installer
  (omnibus-chef-server) which is also responsible for installing and
  configuring all of the supporting components of the Chef Server.

* `chef_wm`: The "wm" stands for [webmachine][]. This OTP application
  contains the core of the erchef REST API implemented on top of the
  Webmachine toolkit. The URL routing that matches URLs with Erlang
  modules handling requests for those URLs is defined in
  `priv/dispatch.conf`. The README file in that repo has a more
  detailed overview.

* `chef_objects`: Contains Erlang type definitions for core Chef
  objects and serialization code for going between the Erlang
  representation and JSON.

* `chef_authn`: Implements Chef's HTTP request signing and
  verification protocol. This library can be leveraged to build
  Erlang-based client tools that interact with the Chef Server or new
  server add-ons that need to authenticate requests as erchef does.

* `chef_index`: Handles erchef's interaction with Solr and the
  RabbitMQ queue used to for the indexing data flow.

* `chef_db`: All of erchef's interaction with the RDBMS goes through
  chef_db. The base schema and prepared queries can be found in the
  `priv` directory of this project. This project uses [sqerl][]
  as a light-weight RDBMS abstraction layer and pooler for database
  connection pooling.

* `chef_certgen`: Used to generate RSA key pairs and X.509
  certificates. Includes a small NIF library that wraps OpenSSL code
  to support Chef's desired formats.

* `depsolver`: A backtracking dependency solver for resolving cookbook
  version dependencies.

* `fast_log`: A simple logging library. We intend to revisit this and
  will likely replace fast_log with [lager][].

* `stats_hero`: Supports aggregating metrics at the HTTP request
  level, sending to a [StatsD][] server over UDP, and providing
  request-level metrics for request logging.

## Release tagging and branch management ##

Releases are tagged off of the *master* branch using git annotated
tags (`git tag -a x.y.z`).

Erchef uses the [rebar_lock_deps_plugin][] to create a
`rebar.config.lock` file that lists all dependencies locked to a git
SHA. This allows builds of erchef to be reproducible.

All erchef code lives in supporting repositories; the
`rebar.config.lock` file must be updated to pull in new code. You can
update the lock file and bump the OTP release version number like
this:

    make prepare_release

The `prepare_release` target takes the following actions:

1. remove all local deps via `make distclean`

2. fetch all dependencies **without using the lock file**. This is
   where new code is brought in.

3. Run the `lock-deps` plugin to regenerate the `rebar.config.lock` file
   based on the git SHAs of the local dependencies fetched in step 2.

4. Bump the "z" version in `rel/reltool.config`. Depending on the
   changes being pulled in, you may need to make a larger version
   bump to conform with [semver](http://semver.org/).

You can trigger a commit of the updated `rebar.config.lock` file and
`rel/reltool.config` along with a formatted summary of changes in the
deps using the following rebar command provided by the
[rebar_lock_deps_plugin][] (and already included in erchef deps):

    rebar commit-release

If this is a known good build, you can generate a standard tag based
on the version found in `rel/reltool.config` like so:

    rebar tag-release

The changes made by `prepare_release` can be pushed to a feature
branch for integration testing prior to merging to master.

[rebar_lock_deps_plugin]: https://github.com/seth/rebar_lock_deps_plugin/
[lager]: https://github.com/basho/lager
[rebar_lock_deps_plugin]: https://github.com/seth/rebar_lock_deps_plugin/
[sqerl]: https://github.com/opscode/sqerl
[StatsD]: https://github.com/etsy/statsd
[webmachine]: https://github.com/basho/webmachine

## License ##

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Copyright:**       | Copyright (c) 2011-2012 Opscode, Inc.
| **License:**         | Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
