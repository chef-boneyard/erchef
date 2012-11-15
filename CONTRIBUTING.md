# Contributing to Chef

We are glad you want to contribute to Chef! The first step is the desire to improve the project.

You can find the answers to additional frequently asked questions [on the wiki](http://wiki.opscode.com/display/chef/How+to+Contribute).

## Quick-contribute

*   Create an account on our [bug tracker](http://tickets.opscode.com)
*   Sign our contributor agreement (CLA) [
online](https://secure.echosign.com/public/hostedForm?formid=PJIF5694K6L)  
    (keep reading if you're contributing on behalf of your employer)
* [Create a ticket][] for your change.
* Link to your patch as a rebased git branch or pull request from the ticket
* Resolve the ticket as fixed

We regularly review contributions and will get back to you if we have any suggestions or concerns.

[Create a ticket]: http://tickets.opscode.com/secure/CreateIssueDetails!init.jspa?pid=10000&components=10002&issuetype=1&Create=Create

## The Apache License and the CLA/CCLA

Licensing is very important to open source projects, it helps ensure the software continues to be available under the terms that the author desired.
Chef uses the Apache 2.0 license to strike a balance between open contribution and allowing you to use the software however you would like to. 

The license tells you what rights you have that are provided by the copyright holder. It is important that the contributor fully understands what rights
they are licensing and agrees to them. Sometimes the copyright holder isn't the contributor, most often when the contributor is doing work for a company.

To make a good faith effort to ensure these criteria are met, Opscode requires a Contributor License Agreement (CLA) or a Corporate Contributor License
Agreement (CCLA) for all contributions. This is without exception due to some matters not being related to copyright and to avoid having to continually
check with our lawyers about small patches.

It only takes a few minutes to complete a CLA, and you retain the copyright to your contribution.

You can complete our contributor agreement (CLA) [
online](https://secure.echosign.com/public/hostedForm?formid=PJIF5694K6L).  If you're contributing on behalf of your employer, have
your employer fill out our [Corporate CLA](https://secure.echosign.com/public/hostedForm?formid=PIE6C7AX856) instead.

## Ticket Tracker (JIRA)

The [ticket tracker](http://tickets.opscode.com) is the most important documentation for the code base. It provides significant historical information,
such as:

* Which release a bug fix is included in
* Discussion regarding the design and merits of features
* Error output to aid in finding similar bugs

Each ticket should aim to fix one bug or add one feature. 

## Using git

You can get a copy of the erchef repositories by cloning erchef (this repo) and running `make clone_for_dev`. See the erchef README for details.

For collaboration purposes, it is best if you create a Github account and fork the repository to your own account. 
Once you do this you will be able to push your changes to your Github repository for others to see and use.

### Branches and Commits

You should submit your patch as a git branch named after the ticket, such as CHEF-1337.
This is called a _topic branch_ and allows users to associate a branch of code with the ticket. 

It is a best practice to have your commit message have a _summary line_ starting with the ticket number that describes the fix or feature, followed by an empty line and then a brief description of the commit. This also helps other contributors
understand the purpose of changes to the code.

    CHEF-3435: Create deploy dirs before calling scm_provider
        
    The SCM providers have an assertation that requires the deploy directory to
    exist. The deploy provider will create missing directories, we don't converge
    the actions before we call run_action against the SCM provider, so it is not
    yet created. This ensures we run any converge actions waiting before we call
    the SCM provider.

Remember that not all users use Chef in the same way or on the same operating systems as you, so it is
helpful to be clear about your use case and change so they can understand it even when it doesn't apply to them.

### Github and Pull Requests

All of Opscode's open source projects are available on [Github](http://www.github.com/opscode).

We don't require you to use Github, and we will even take patch diffs attached to tickets on the tracker. 
However Github has a lot of convenient features, such as being able to see a diff of changes between a
pull request and the main repository quickly without downloading the branch.

If you do choose to use a pull request, please provide a link to the pull request from the ticket __and__
a link to the ticket from the pull request. Because pull requests only have two states, open and closed,
we can't easily filter pull requests that are waiting for a reply from the author for various reasons.

### More information

Additional help with git is available on the [Working with Git](http://wiki.opscode.com/display/chef/Working+with+Git) wiki page.

## Unit Tests, Dialyzer, and Integration Tests

Erchef is composed of a number of sub projects each with its own git repository. Each project has a `Makefile` with some standard targets. In general, running a bare `make` in a sub project will compile, run unit tests, and run dialyzer, an Erlang type verification tool.

Once the sub project `make` is clean, the subproject can be loaded into the projects that depend on it and the local unit test and dialyzer runs can be repeated.

Finally, a provisional erchef build is created by either using `make prepare_release` or manually editing the rebar.config.lock file. This provides a build that can be built into a complete omnibus-chef package at which point the chef-pedant integration test can be run.

Any new feature should have unit tests included with the patch with good code coverage to help protect it from future changes. New exported functions should have dialyzer type specs and dialyzer should run without reporting any warnings.

## Code Review

Opscode regularly reviews code contributions and provides suggestions for improvement in the code itself or the implementation.

We find contributions by searching the ticket tracker for _resolved_ tickets with a status of _fixed_. If we have feedback we will
reopen the ticket and you should resolve it again when you've made the changes or have a response to our feedback. When we believe
the patch is ready to be merged, we will tag the _Code Reviewed_ field with _Reviewed_.

Depending on the project, these tickets are then merged within a week or two, depending on the current release cycle.

## Release Cycle

The versioning for the Chef project is X.Y.Z.

* X is a major release, which may not be fully compatible with prior major releases
* Y is a minor release, which adds both new features and bug fixes
* Z is a patch release, which adds just bug fixes

Major releases and have historically been once a year. Minor releases for Chef average every two months and patch releases come as needed.

There are usually beta releases and release candidates (RC) of major and minor releases announced on 
the [chef-dev mailing list](http://lists.opscode.com/sympa/info/chef-dev). Once an RC is released, we wait at least three
days to allow for testing for regressions before the final release. If a blocking regression is found then another RC is made containing
the fix and the timer is reset.

Once the official release is made, the release notes are available on the [Opscode blog](http://www.opscode.com/blog).

## Working with the community

These resources will help you learn more about Chef and connect to other members of the Chef community:

* [chef](http://lists.opscode.com/sympa/info/chef) and [chef-dev](http://lists.opscode.com/sympa/info/chef-dev) mailing lists
* #chef and #chef-hacking IRC channels on irc.freenode.net
* [Community Cookbook site](http://community.opscode.com)
* [Chef wiki](http://wiki.opscode.com/display/chef)
* Opscode Chef [product page](http://www.opscode.com/chef)

