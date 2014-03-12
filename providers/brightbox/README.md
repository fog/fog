# Brightbox Cloud module for fog (The Ruby cloud services library)

This gem is a modular for the `fog` gem that allows you to manage resources in
the Brightbox Cloud.

It is included by the main `fog` metagem but can used as an independent library
in other applications.

This includes support for the following services:

* Compute
  * Images
  * Load Balancers
  * SQL Cloud instances

Currently all services are grouped within `compute` but will be moved to their
own sections when standardisation of fog progresses.

## Installation

Add this line to your application's Gemfile:

    gem "fog-brightbox"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fog-brightbox

## Usage

Please see the following references for instructions using the main `fog` gem
and its modules:

* https://github.com/fog/fog
* http://fog.io/
* http://rubydoc.info/gems/fog/

## Contributing

`fog` modules are kept within the main repo.

1. Fork it ( http://github.com/fog/fog/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
