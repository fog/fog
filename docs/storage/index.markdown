---
layout: default
title:  Storage
---

Having Ruby experience makes you hirable; but how can you stand out? You need to demonstrate your abilities. What better way than using Ruby and "the cloud" to store and serve your resume!

In this blog post you will learn to use <a href="http://github.com/fog/fog">fog</a> - the cloud computing library - to upload your resume to Amazon's <a href="http://aws.amazon.com/s3/">Simple Storage Service</a> (S3), Rackspace's <a href="http://www.rackspacecloud.com/cloud_hosting_products/files">CloudFiles</a> or Google's <a href="http://code.google.com/apis/storage/">Storage for Developers</a>.

Here's my out of date resume stored on <a href="http://geemus.s3.amazonaws.com/resume.html">S3</a>, <a href="http://c0023559.cdn2.cloudfiles.rackspacecloud.com/resume.html">CloudFiles</a> and <a href="https://geemus.commondatastorage.googleapis.com/resume.html">Google Storage</a>; programmatically stored in the cloud using this tutorial. NOTE: my boss would like me to add that I'm not currently looking for a new gig ;)

Check out those cloud-specific URLs! You could put all three in your job application, add the Ruby source for how you did it, and have your choice of Ruby jobs for being so awesome!

How? The all-clouds-in-one library of choice is <a href="https://github.com/fog/fog">fog</a>.

## Installing fog

fog is distributed as a RubyGem:

    gem install fog

Or add it in your application's Gemfile:

    gem "fog"

## Using Amazon S3 and fog

Sign up for an account <a href="http://aws-portal.amazon.com/gp/aws/developer/subscription/index.html?productCode=AmazonS3">here</a> and copy down your secret access key and access key id from <a href="http://aws-portal.amazon.com/gp/aws/developer/account/index.html?action=access-key">here</a>. We are about to get into the code samples, so be sure to fill in anything in ALL_CAPS with your own values!

First, create a connection with your new account:

    require 'rubygems'
    require 'fog'

    # create a connection
    connection = Fog::Storage.new({
      :provider                 => 'AWS',
      :aws_access_key_id        => YOUR_SECRET_ACCESS_KEY_ID,
      :aws_secret_access_key    => YOUR_SECRET_ACCESS_KEY
    })

    # First, a place to contain the glorious details
    directory = connection.directories.create(
      :key    => "fog-demo-#{Time.now.to_i}", # globally unique name
      :public => true
    )

    # list directories
    p connection.directories

    # upload that resume
    file = directory.files.create(
      :key    => 'resume.html',
      :body   => File.open("/path/to/my/resume.html"),
      :public => true
    )

If you are anything like me, you will continually tweak your resume. Pushing updates is easy:

    file.body = File.open("/path/to/my/resume.html")
    file.save

As you can see, cloud storage files in fog are a lot like an ActiveRecord model. Attributes that can be changed and a `#save` method that creates or updates the stored file in the cloud.

But if it took you longer to realize the mistake you might not still have file around, but you've got options.

directory = connection.directories.get("proclamations1234567890")

    # get the resume file
    file = directory.files.get('resume.html')
    file.body = File.open("/path/to/my/resume.html")
    file.save

    # also, create(attributes) is just new(attributes).save, so you can also do:
    file = directory.files.new({
      :key    => 'resume.html',
      :body   => 'improvements',
      :public => true
    })
    file.save

## Backing up your files

Now you've got a bunch of files in S3: your resume, some code samples,
and maybe some pictures of your cat doing funny stuff. Since this is
all of vital importance, you need to back it up.

    # copy each file to local disk
    directory.files.each do |s3_file|
      File.open(s3_file.key, 'w') do |local_file|
        local_file.write(s3_file.body)
      end
    end

One caveat: it's way more efficient to do this:

    # do two things per file
    directory.files.each do |file|
      do_one_thing(file)
      do_another_thing(file)
    end

than it is to do this:

    # do two things per file
    directory.files.each do |file|
      do_one_thing(file)
    end.each do |file|
      do_another_thing(file)
    end

The reason is that the list of files might be large. Really
large. Eat-all-your-RAM-and-ask-for-more large. Therefore, every time
you say `files.each`, fog makes a fresh set of API calls to Amazon to
list the available files (Amazon's API returns a page at a time, so
fog works a page at a time in order to keep its memory requirements sane).

## Sending it out

Alright, so you (eventually) become satisfied enough to send it off, what is the URL endpoint to your resume?

    puts file.public_url

Pop that link in an email and you should be ready to cruise job ads and send your resume far and wide (Engine Yard is <a href="http://www.engineyard.com/company/careers/wanted-head-in-the-clouds-engineer">hiring</a>, so check us out!). Now you are set, unless you are interviewing for Google, or Rackspace... Both of these companies have their own cloud storage services, so using Amazon S3 might not be the foot in the door you hoped for.

More clouds? How much extra stuff will you have to do for these services!?! Hardly anything needs to change, you just have to pass slightly different credentials in, but I'm getting ahead of myself.

## Google Storage for Developers

Sign up <a href="http://gs-signup-redirect.appspot.com/">here</a> and get your credentials <a href="https://sandbox.google.com/storage/m/">here</a>.

    connection = Fog::Storage.new({
      :provider                         => 'Google',
      :google_storage_access_key_id     => YOUR_SECRET_ACCESS_KEY_ID,
      :google_storage_secret_access_key => YOUR_SECRET_ACCESS_KEY
    })

## Rackspace CloudFiles

Rackspace has <a href="http://www.rackspacecloud.com/cloud_hosting_products/files">Cloud Files</a> and you can sign up <a href="https://www.rackspacecloud.com/signup">here</a> and get your credentials <a href="https://manage.rackspacecloud.com/APIAccess.do">here</a>.

    connection = Fog::Storage.new({
      :provider           => 'Rackspace',
      :rackspace_username => RACKSPACE_USERNAME,
      :rackspace_api_key  => RACKSPACE_API_KEY
    })

If you work with the European cloud from Rackspace you have to add the following:

    :rackspace_auth_url => "lon.auth.api.rackspacecloud.com"

Then create, save, destroy as per fog-for-AWS. The `:public => true` option when creating directories (see above) is important for Rackspace; your folder and files won't be shared to Rackspace's CDN and hence your users without it.  Similarly the `:public =&gt; true` on files is important for AWS and Google or they will be private.

## Local Storage

While you are working out the kinks you might not want to do everything live though, ditto for while you are running tests, so you have a couple options to try before you buy.  First, you can use a local provider to store things in a directory on your machine.

    connection = Fog::Storage.new({
      :provider   => 'Local',
      :local_root => '~/fog'
    })

## Mocking out Cloud Storage

Of course when you are testing or developing you can always just use the mocks (at least for AWS and Google, Rackspace still needs mocks implemented if you are looking for somewhere to contribute).  They emulate the behavior of the external systems without actually using them.  It is as simple as:

    Fog.mock!
    connection = Fog::Storage.new(config_hash)

## Cleaning up

Fog takes care of the rest so you can focus on your cover letter. And with the awesome cover letter and cloud delivered resume you are probably a shoe-in. So all that is left is to cleanup that leftover job hunt residue.

    file.destroy
    directory.destroy

## Checking if a file already exists

Sometimes you might want to find out some information about a file without retrieving the whole file. You can do that using 'head'.

    #returns nil if the file doesn't exist
    unless directory.files.head('resume.html')
       #do something, like creating the file
    end
    
    #returns a hash with the following data:
    # 'key' - Key for the object
    # 'Content-Length' - Size of object contents
    # 'Content-Type' - MIME type of object
    # 'ETag' - Etag of object
    # 'Last-Modified' - Last modified timestamp for object
    puts directory.files.head('resume.html')

## Summary

All done. Try out all the different options and let me know if you have any bugs or issues.  I also wrote up a more <a href="https://gist.github.com/710869">consolidated example as a script</a> that you can use for reference.

Bonus, note the `Fog.mock!` command. In your tests you can easily mock out calls to cloud providers.

Please let me know in the comments if you got a new Ruby job because you hosted your CV on 3 different Cloud Stores without getting your hands dirty.

Have questions or comments?  Hop into <a href="irc://irc.freenode.net/">#ruby-fog</a> on freenode, ping <a href="http://twitter.com/fog">@fog</a> or <a href="http://twitter.com/geemus">@geemus</a>.

And please always remember that I accept high fives and contributions!
