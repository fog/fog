---
layout: default
title:  DNS
---

The power and flexibility of the cloud are amazing. But sometimes it can be a pain to chase your resources around and keep everything up to date. This is especially true of keeping track of addresses for DNS, but thankfully more and more API driven options are available, allowing you to automate your DNS to keep up with your hardware changes.

## Setup

First, make sure you have fog installed:

    gem install fog

For this first example we will use Zerigo (see below for how to use other providers). You can signup for Zerigo DNS <a href="https://www.zerigo.com/signup/dns">here</a>. Gather up your new credentials to initialize a connection to the service:

    require 'rubygems'
    require 'fog'

    # create a connection to the service
    dns = Fog::DNS.new({
      :provider     => 'Zerigo',
      :zerigo_email => ZERIGO_EMAIL,
      :zerigo_token => ZERIGO_TOKEN
    })

## Getting in the Zone

The first thing you need to do to prepare for your DNS excursion is create a zone for your domain.  The zone will contain all of the more specific records that you will create later.  You will just need to specify the domain, which should be your url without the 'http' or 'www' parts, and an email address.  Then you can create the zone with your DNS connection:<!--more-->

    zone = @dns.zones.create(
      :domain => 'example.com',
      :email  => 'admin@example.com'
    )

Now that you have a zone you will need to update your registrar to let them know what DNS servers are responsible for your domain.  You can ask the zone what values to use:

    zone.nameservers

## Spinning Records

With your new zone in hand you can add records as needed.  First and foremost you will probably want the 'www' version of your site to point to whatever your ip might be:

    record = @zone.records.create(
      :ip   => '1.2.3.4',
      :name => 'example.com',
      :type => 'A'
    )

Adding other records is similarly easy, for instance if we want 'www.example.com' to go to the same place, we can use a cname record:

    record = @zone.records.create(
      :ip   => 'example.com',
      :name => 'www',
      :type => 'CNAME'
    )

Or, similarly you might want to have your blog elsewhere:

    record = @zone.records.create(
      :ip   => '4.3.2.1',
      :name => 'blog.example.com',
      :type => 'A'
    )

You can add more specifics if you need to, but reasonable defaults make it just that easy.  You can also add any other kind of DNS record you might need for mail or other purposes, you can find a nice overview of record options and types <a href="http://en.wikipedia.org/wiki/Domain_Name_System#DNS_resource_records">on Wikipedia</a>.

## No Zerigo? No Problem

If you already have an account with another service you can just as easily use this same code with different credentials. fog currently supports <a href="http://aws.amazon.com/route53/">AWS Route 53</a>, <a href="http://bluebox.net">Blue Box</a>, <a href="http://dnsimple.com">DNSimple</a>, <a href="http://www.linode.com">Linode</a>, <a href="http://www.rackspace.com">Rackspace</a>, <a href="http://www.slicehost.com">Slicehost</a> and <a href="http://www.zerigo.com/managed-dns">Zerigo</a>; so you can have your pick.  As an example you can connect to AWS instead of Zerigo:

    dns = Fog::DNS.new({
      :provider               => 'AWS',
      :aws_access_key_id      => AWS_ACCESS_KEY_ID,
      :aws_secret_access_key  => AWS_SECRET_ACCESS_KEY
    })

## Go Forth and Resolve

You can see an example of reusing code like this in the <a href="https://github.com/geemus/fog/blob/master/examples/dns_tests.rb">examples folder</a>. Using this makes it easier to give yourself shortcuts to your cloud servers and manage how clients and users access them as well. It is great to have this flexibility so that you can modify your cloud infrastructure as needed while keeping everything ship shape. It also provides a nice way to create custom subdomains for users and just generally round out your cloud solution.
