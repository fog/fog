---
layout: default
title:  Getting Started
---

First off, install the gem:

    $ gem install fog

## Setting Up Local Storage

We will be using local storage in the example, so first off make a local directory that things can go in.

    $ mkdir ~/fog

Now We can start building out our script to play with.  First thing is first, we will setup a storage connection.

    Fog::Storage.new(
      :local_root => '~/fog',
      :provider   => 'Local',
    )
