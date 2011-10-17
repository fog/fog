---
layout: default
title:  Compute
---

Compute is the lifeblood of the cloud, but with great power comes great complication. Compute opens up huge swaths of potential, but it varies greatly in both capabilities and usage from provider to provider. Thankfully fog helps to abstract these idiosyncrasies to provide a more seamless experience.

## Installing fog

fog is distributed as a RubyGem:

    gem install fog

Or for bundler users, you can add it in your Gemfile:

    gem "fog"

## Using Amazon EC2 and fog

Sign up for an account <a href="http://aws-portal.amazon.com/gp/aws/developer/subscription/index.html?productCode=AmazonEC2">here</a> and copy down your secret access key and access key id from <a href="http://aws-portal.amazon.com/gp/aws/developer/account/index.html?action=access-key">here</a>. We are about to get into the code samples, so be sure to fill in anything in ALL_CAPS with your own values!

First, create a connection with your new account:

    require 'rubygems'
    require 'fog'

    # create a connection
    connection = Fog::Compute.new({
      :provider                 => 'AWS',
      :aws_secret_access_key    => YOUR_SECRET_ACCESS_KEY,
      :aws_access_key_id        => YOUR_SECRET_ACCESS_KEY_ID
    })

With that in hand we are ready to start making EC2 calls!

## Servers the EC2 way

Creating a server on EC2 is very easy if you are willing to accept the defaults (the smallest server size, using Ubuntu 10.04 LTS). NOTE: the default EC2 image uses the 'ubuntu' username, rather than 'root' like other services.

    server = connection.servers.create

You can then list your servers to see that it now appears:

    connection.servers

Rather than worrying about the whole list, we can also just get the latest data for just our server:

    server.reload

That can get tedious quickly however, especially when servers can take several minutes to boot.  Fog has `wait_for` for cases like this and `ready?` for checking to see when a server has completed its start up.

    server.wait_for { ready? }

Once we are done with that we can shut it down.

    server.destroy

## Bootstrap: Servers the fog Way

Cycling servers is great, but in order to actually ssh in we need to setup ssh keys and open ports.  But rather than worrying about the nitty gritty, we will utilize `bootstrap`.  NOTE: normally we could leave out username and use the default (root), but the default Ubuntu from Canonical uses the ubuntu username instead.

    server = connection.servers.bootstrap(:private_key_path => '~/.ssh/id_rsa', :public_key_path => '~/.ssh/id_rsa.pub', :username => 'ubuntu')

Bootstrap will create the server, but it will also make sure that port 22 is open for traffic and has ssh keys setup.  In order to hook everything up it will need the server to be running, so by the time it finishes it will be ready.  You can then make commands to it directly:

    server.ssh('pwd')
    server.ssh(['pwd', 'whoami'])

These return an array of results, where each has stdout, stderr and status values so you can check out what your commands accomplished.  Now just shut it down to make sure you don't continue getting charged.

    server.destroy

## Rackspace Cloud Servers

Rackspace has <a href="http://www.rackspacecloud.com/cloud_hosting_products/servers">Cloud Servers</a> and you can sign up <a href="https://www.rackspacecloud.com/signup">here</a> and get your credentials <a href="https://manage.rackspacecloud.com/APIAccess.do">here</a>.

    # create a connection
    connection = Fog::Compute.new({
      :provider           => 'Rackspace',
      :rackspace_username => RACKSPACE_USERNAME,
      :rackspace_api_key  => RACKSPACE_API_KEY
    })

If you work with the European cloud from Rackspace you have to add the following:

    :rackspace_auth_url => "lon.auth.api.rackspacecloud.com"

We will skip over learning how to do this the 'Rackspace Way' and instead jump right to using bootstrap to get their smallest Ubuntu 10.04 LTS server.

    server = connection.servers.bootstrap

You can run all the same ssh commands and do what you need to, then once again shutdown to ensure you are not charged once you are done.

    server.destroy

## Mocking out Compute

You can also start any of these scripts with `Fog.mock!` or start the fog interactive tool from the command line with `FOG_MOCK=true fog` to run in mock mode. In this mode commands are run as local simulation, so no cloud resources are ever consumed and things operate much faster.

## Cleaning up

To cover your tracks its a good idea to check for running servers and shut them down, here is one way you might do that.

    connection.servers.select {|server| server.ready? && server.destroy}

## Summary

Compute can be tricky, but the abstractions in fog make it much easier to get started.  With your servers up and running you can then focus on the task at hand and get some work done.  Congratulations on adding a new tool to your arsenal and let us know what we can do better.
