# Getting Started with HP Cloud Extensions to Ruby Fog Bindings

[HP Cloud](http://www.hpcloud.com) has been creating and contributing bindings so
that developers can work with Ruby Fog and the HP Cloud services based on
[OpenStack](http://www.openstack.org/). By using the HP Cloud Extensions to Fog,
developers can write applications using Ruby that interacts with the
HP Cloud Services without having to deal with the underlying REST API or
JSON/XML document formats. We have officially turned these bindings over to the
Ruby Fog community where you can contribute and develop additional functionality
around these bindings.

This section of documentation provides information, examples and articles for working with the different HP Cloud services such as Compute, Object Storage and others.

Please note that HP Cloud recently released version 13.5 which updates and adds functionality provided by OpenStack Havana. Some of our HP Ruby Fog examples are developed to work with earlier versions so please take note which HP Cloud version you are working with.

**Note:** The Networking service examples only work with version 13.5.

## Installation

To install and use HP Cloud Ruby bindings for Fog, please install the [latest release](http://fog.io/) of Fog.

Then follow the installation instructions for the operating system you are using and connect to the service:

* [Installation Instructions](https://github.com/fog/fog/blob/master/lib/fog/hp/docs/install.md)
* [Connecting to the Service](https://github.com/fog/fog/blob/master/lib/fog/hp/docs/connect.md)

## Requirements

For working with the HP Cloud Extension to Fog, the following pre-requisites are needed:

* HP Cloud Services account. If you have not already signed up, please [sign up for your free trial](http://www.hpcloud.com/free-trial).
* Ruby version 1.8.x or 1.9.x
* `fog` gem


## Examples

Apart from the overall [Fog documentation](http://fog.io), we have HP Cloud specific examples that will help you in using the Ruby Fog bindings with HP Cloud services.

[Examples for using Fog with HP Cloud Services](https://github.com/fog/fog/blob/master/lib/fog/hp/examples/getting_started_examples.md)

## Articles

In addition to the examples we have provided, for Compute, Object Storage, and other HP Cloud services, we wanted to give you a few additional tips and "how-tos' to make using your Ruby Fog bindings even easier. Take a look at the articles listed below to find out more!

* [Using authentication caching](https://github.com/fog/fog/blob/master/lib/fog/hp/articles/auth_caching.md)

## Additional Resources
* [Fog cloud library](http://fog.io)
* [Fog documentation](http://rubydoc.info/gems/fog)
* [Fog Github repo](https://github.com/fog/fog)
* [Fog Release Notes](https://github.com/fog/fog/blob/master/changelog.txt)

## Support and Feedback

Your feedback is essential to the maturity of the bindings and is highly appreciated! If you have specific issues with the HP Cloud Extensions to Fog bindings, please file an [issue via Github](https://github.com/fog/fog/issues).

