# Getting Started with Fog and OpenStack

This document explains how to get started using Fog with [OpenStack](http://openstack.org)

## Requirements

### Ruby

Fog officially supports Ruby 2.0.0, 1.9.3, 1.9.2, and 1.8.7 (also known as Matz Ruby Interpreter or MRI). While not officially supported, fog has been known to work with Rubinus and JRuby.

Ruby 2.0.0 is suggested for new projects. For information on installing Ruby please refer to the [Ruby download page](http://www.ruby-lang.org/en/downloads/).

### RubyGems

RubyGems is required to access the Fog gem. For information on installing RubyGems, please refer to [RubyGems download page](http://rubygems.org/pages/download).

### Bundler (optional)

Bundler helps manage gem dependencies and is recommended for new projects. For more information about bundler, please refer to the [bundler documentation](http://gembundler.com/).

## Installation

To install Fog via RubyGems run the following command:

    $ gem install fog

To install Fog via Bundler add `gem 'fog'` to your `Gemfile`. This is a sample `Gemfile` to install Fog:

```ruby
source 'https://rubygems.org'

gem 'fog'
```

After creating your `Gemfile` execute the following command to install the libraries:

	bundle install	

## Next Steps

Now that you have installed Fog and obtained your credentials, you are ready to begin exploring the capabilities of the Rackspace Open Cloud and Fog using `irb`.

Start by executing the following command:

	irb
	
Once `irb` has launched you will need to require the Fog library.

If using Ruby 1.8.x execute the following command:

```ruby
require 'rubygems'
require 'fog'
```

If using Ruby 1.9.x execute the following command:

```ruby
require 'fog'
```

You should now be able to execute the following command to see a list of services Fog provides for the Rackspace Open Cloud:

```ruby
Fog::OpenStack.services
```

These services can be explored in further depth in the following documents:

* [Compute](compute.md)
* [Storage (Swift)](storage.md)

## Additional Resources
* [fog.io](http://fog.io)
* [Fog rdoc](http://rubydoc.info/gems/fog)
* [Fog Github repo](https://github.com/fog/fog)
* [Release Notes](https://github.com/fog/fog/blob/master/changelog.txt)


## Support and Feedback
Your feedback is appreciated! If you have specific issues with the **fog** SDK, you should file an [issue via Github](https://github.com/fog/fog/issues).
