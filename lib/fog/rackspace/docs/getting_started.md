# Getting Started with Fog and the Rackspace Cloud

This document explains how to get started using Fog with the [Rackspace Cloud](http://www.rackspace.com/cloud/).

## Requirements

### Ruby

Fog officially supports Ruby 2.1.1, 2.1.0, 2.0.0, 1.9.3, 1.9.2, and 1.8.7 (also known as Matz Ruby Interpreter or MRI). While not officially supported, fog has been known to work with Rubinus and JRuby.

Ruby 1.9.3 is suggested for new projects. For information on installing Ruby please refer to the [Ruby download page](http://www.ruby-lang.org/en/downloads/).

### RubyGems

RubyGems is required to access the Fog gem. For information on installing RubyGems, please refer to [RubyGems download page](http://rubygems.org/pages/download).

### Bundler (optional)

Bundler helps manage gem dependencies and is recommended for new projects. For more information about bundler, please refer to the [bundler documentation](http://gembundler.com/).

## Credentials

To obtain credentials for the US Rackspace Cloud, please sign up for an account at [US Rackspace Open Cloud](https://cart.rackspace.com/cloud/). Once an account is created, you can login to the [Cloud Control Panel (US)](https://mycloud.rackspace.com/), find your credentials by clicking on your username in the top right corner, and then select API keys.

Likewise, you can create an account on our UK Rackspace Open Cloud by signing up at [UK Rackspace Open Cloud](https://buyonline.rackspace.co.uk/cloud/userinfo?type=normal) and then logging into [Cloud Control Panel (UK)](https://mycloud.rackspace.co.uk/).

You will use the credentials when you explore fog services in the [Next Steps](#next-steps) section.

## Installation

To install Fog via RubyGems run the following command:

    $ gem install fog

To install Fog via Bundler add `gem 'fog'` to your `Gemfile`. This is a sample `Gemfile` to install Fog:

	source 'https://rubygems.org'

	gem 'fog'

After creating your `Gemfile` execute the following command to install the libraries:

	bundle install	

## Next Steps

Now that you have installed Fog and obtained your credentials, you are ready to begin exploring the capabilities of the Rackspace Open Cloud and Fog using `irb`.

Start by executing the following command:

	irb
	
Once `irb` has launched you will need to require the Fog library.

If using Ruby 1.8.x execute the following command:

	require 'rubygems'
	require 'fog'

If using Ruby 1.9.x execute the following command:

	require 'fog'

You should now be able to execute the following command to see a list of services Fog provides for the Rackspace Open Cloud:

	Fog::Rackspace.services

These services can be explored in further depth in the following documents:

* [Next Generation Cloud Servers™ (compute_v2)](compute_v2.md)
* [Cloud Files™ (storage)](storage.md)
* [Cloud Block Storage (block_storage)](block_storage.md)
* [Auto Scale (auto_scale)](auto_scale.md)
* [Queues](queues.md)

**Note**: The compute service provides an interface to the First Geneneration Cloud Servers™ (compute). This service is deprecated. Users are encouraged to use Next Geneneration Cloud Servers™ (compute_v2).

## Additional Resources
* [fog.io](http://fog.io)
* [Fog rdoc](http://rubydoc.info/gems/fog)
* [Fog Github repo](https://github.com/fog/fog)
* [Release Notes](https://github.com/fog/fog/blob/master/changelog.txt)
* [developer.rackspace.com](http://developer.rackspace.com/)

## Support and Feedback
Your feedback is appreciated! If you have specific issues with the **fog** SDK, you should file an [issue via Github](https://github.com/fog/fog/issues).

For general feedback and support requests, please visit: https://developer.rackspace.com/support.
