---
layout: default
title:  Getting Started
---

First off, install the gem:

    $ gem install fog

## Setting Up Local Storage

We will be using Local storage in the example.  Local storage provides the same api that cloud storage services in fog do, but without the bother of needing to signup for stuff or pay extra money.

First, make a local directory to hold your data.

    $ mkdir ~/fog

Now we can start writing our script, first off we should require fog.

    require 'rubygems'
    require 'fog'

Now in order to play with our data we need to setup a storage connection.

    storage = Fog::Storage.new({
      :local_root => '~/fog',
      :provider   => 'Local'
    })

`storage` will now contain our storage object, configured to use the Local provider from our specified directory.

## Storing Data

Now that you have cleared the preliminaries you are ready to start storing data. Storage providers in fog segregate files into `directories` to make it easier to organize things. So lets create a directory so we can see that in action.

    directory = storage.directories.create(
      :key => 'data'
    )

To make sure it was created you can always check in your filesystem, but we can also check from inside fog.

    storage.directories

Progress! Now it is time to actually create a file inside our new directory.

    file = directory.files.create(
      :body => 'Hello World!',
      :key  => 'hello_world.txt'
    )

We should now have our file, first we can open it up and make sure we are on the right track.

    $ open ~/fog/hello_world.txt

It is much more likely that you will want to see what files you have from inside fog though.

    directory.files

Now that we have run through all the basics, lets clean up our mess.

    file.destroy
    directory.destroy

After that you should be able to check your directory list in fog or your filesystem and see you are safely back to square one.

## Next Steps

Using the same interface you can also practice working against a real provider (such as Amazon S3). Rather than worrying about signing up for an account right away though, we can use mocks to simulate S3 while we practice.

This time we will turn on mocking and then, just like before, we will need to make a connection.

    Fog.mock!
    storage = Fog::Storage.new({
      :aws_access_key_id      => 'fake_access_key_id',
      :aws_secret_access_key  => 'fake_secret_access_key',
      :provider               => 'AWS'
    })

You may notice that we used bogus credentials, this is fine since we are just simulating things. To use real S3 you can simply omit Fog.mock! and swap in your real credentials.

If you'd like to turn off mocking after turning it on, you can do it at any time and every subsequent connection will be a real connection.

    # Turn on mocking
    Fog.mock!

    # Create a mock connection to S3
    storage = Fog::Storage.new({
      :aws_access_key_id => "asdf",
      :aws_secret_access_key => "asdf",
      :provider => "AWS"
    })

    # Turn off mocking
    Fog.unmock!

    # Create a real connection to S3
    storage = Fog::Storage.new({
      :aws_access_key_id => "asdf",
      :aws_secret_access_key => "asdf",
      :provider => "AWS"
    })

Don't worry about your losing mock data, it stays around until you reset it or until your process exits.

    # Reset all mock data
    Fog::Mock.reset

Congratulations and welcome to the cloud!  Continue your journey at [fog.io](http://fog.io)
