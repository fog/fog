---
layout: default
title:  The Ruby cloud services library
---

Whether you need compute, dns, storage, or a multitude of other services, fog provides an accessible entry point and facilitates cross service compatibility.

Just getting started working with cloud resources? You are not alone, and having so many complicated options makes it hard to know where to start. fog delivers the knowledge of cloud experts to you, helping you to bootstrap your cloud usage and guiding you as your own expertise develops.

By coding with fog from the start you avoid vendor lock-in and give yourself more flexibility to provide value. Whether you are writing a library, designing a software as a service product or just hacking on the weekend this flexibility is a huge boon.

With a rapidly expanding community and codebase the advantages of fog just keep coming. Join us and together we will realize the future of cloud computing.

## Getting Started

    sudo gem install fog

Now type 'fog' to try stuff, confident that fog will let you know what to do. Here is an example of wading through server creation for Amazon Elastic Compute Cloud:

    >> server = Compute[:aws].servers.create
    ArgumentError: image_id is required for this operation

    >> server = Compute[:aws].servers.create(:image_id => 'ami-5ee70037')
    <Fog::AWS::EC2::Server [...]>

    >> server.destroy # cleanup after yourself or regret it, trust me
    true

## Go forth and conquer

Play around and use the console to explore or check out the [getting started guide](/about/getting_started.html) for more details. Once you are reading to start scripting fog, here is a quick hint on how to make connections without the command line thing to help you.

    # create a compute connection
    compute = Fog::Compute.new({:provider => 'AWS', :aws_access_key_id => ACCESS_KEY_ID, :aws_secret_access_key => SECRET_ACCESS_KEY})
    # compute operations go here

    # create a storage connection
    storage = Fog::Storage.new({:provider => 'AWS', :aws_access_key_id => ACCESS_KEY_ID, :aws_secret_access_key => SECRET_ACCESS_KEY})
    # storage operations go here

geemus says: "That should give you everything you need to get started, but let me know if there is anything I can do to help!"

## Contributing

* Find something you would like to work on. For suggestions look for the `easy`, `medium` and `hard` tags in the [issues](http://github.com/fog/fog/issues)
* Fork the project and do your work in a topic branch.
* Add shindo tests to prove your code works and run all the tests using `bundle exec rake`.
* Rebase your branch against fog/fog to make sure everything is up to date.
* Commit your changes and send a pull request.

## Resources

Enjoy, and let me know what I can do to continue improving fog!

* Work through the [fog tutorial](https://github.com/downloads/geemus/learn_fog/learn_fog.tar.gz)
* Read fog's [API documentation](/rdoc)
* Stay up to date by following [@fog](http://twitter.com/fog) and/or [@geemus](http://twitter.com/geemus) on Twitter.
* Get and give help on the [#ruby-fog](irc://irc.freenode.net/ruby-fog) irc channel on Freenode
* Follow release notes and discussions on the [mailing list](http://groups.google.com/group/ruby-fog)
* Report bugs or find tasks to help with in the [issues](http://github.com/fog/fog/issues)
* Learn about [contributing](/about/contributing.html)
* See where fog is used and let the world know how you use it [in the wild](/about/users.html)
* Check out blog posts and other mentions in the [press](/about/press.html)

## Copyright

(The MIT License)

Copyright (c) 2012 [geemus (Wesley Beary)](http://github.com/geemus)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
