---
layout: default
title:  CDN
---

Faster websites are better. <a href="http://www.websiteoptimization.com/speed/tweak/design-factors/">Better experience</a>, <a href="http://exp-platform.com/Documents/IEEEComputer2007OnlineExperiments.pdf">better sales</a>, <a href="http://www.stevesouders.com/blog/2009/07/27/wikia-fast-pages-retain-users/">you name it</a>. Unfortunately, making a website faster can be tough. Thankfully a content distribution network, or CDN, can give you great performance bang for your buck. A CDN helps speed things up by putting copies of your files closer to your users. It's like the difference between pizza delivery from across the street and pizza delivery from the next town over.

The ease and deliciousness are the good news, but until recently CDN's were only available in the big leagues via 'my business guys will talk to your business guys' deals.  Fortunately for us, Amazon recently updated <a href="http://aws.amazon.com/cloudfront/">CloudFront</a>, their CDN service, to allow us to get these benefits with just a credit card and an API call. So now we'll see how you can spend a few minutes to save your users countless hours of load time.

## Preliminaries

First, make sure you have fog installed:

    gem install fog

Now you'll need to <a href="https://aws-portal.amazon.com/gp/aws/developer/subscription/index.html?productCode=AmazonCloudFront">sign up for Cloudfront</a>. Gather up the credentials your new credentials to initialize a connection to the service:

    require 'fog'

    # create a connection to the service
    cdn = Fog::CDN.new({
      :provider               => 'AWS',
      :aws_access_key_id      => AWS_ACCESS_KEY_ID,
      :aws_secret_access_key  => AWS_SECRET_ACCESS_KEY
    }

## Setting Up Your CDN

Now you'll need to create a 'distribution' which represents a mapping from the CDN to your domain. For the examples we'll pretend we are working on 'http://www.example.com', but you can just switch it to your actual domain. Some <a href="http://docs.amazonwebservices.com/AmazonCloudFront/latest/APIReference/CreateDistribution.html">other options</a> are available, but the only other one we need to fill in is OriginProtocolPolicy.  This sets what to do about http vs https. We will use 'match-viewer' which returns the same protocol as the request, but you can also choose 'http-only' which always returns http responses.

    data = cdn.post_distribution({
      'CustomOrigin' => {
        'DNSName'               => 'www.example.com',
        'OriginProtocolPolicy'  => 'match-viewer'
      }
    })

    # parse the response for stuff you'll need later
    distribution_id   = data.body['Id']
    caller_reference  = data.body['CallerReference']
    etag              = data.headers['ETag']
    cdn_domain_name   = data.body['DomainName']

    # wait for the updates to propogate
    Fog.wait_for {
      cdn.get_distribution(distribution_id).body['Status'] ## 'Deployed'
    }

## Getting Served

With the domain name from the distribution in hand you should now be ready to serve content from the edge.  All you need to do is start replacing urls like `http://www.example.com/stylesheets/foo.css` with `#{cdn_domain_name}/stylesheets/foo.css`. Just because you can do something doesn't always mean you should though.  Dynamic pages are not really well suited to CDN storage, since CDN content will be the same for every user.  Fortunately some of your most used content is a great fit.  By just switching over your images, javascripts and stylesheets you can have an impact for each and every one of your users.

Congrats, your site is faster! By default the urls aren't very pretty, something like `http://d1xdx2sah5udd0.cloudfront.net/stylesheets/foo.css`.  Thankfully you can use CNAME config options to utilize something like `http://assets.example.com/stylesheets/foo.css`, if you are interested in learning more about this let me know in the comments.

## Cleaning Up

But, just in case you need to update things I'll run through how you can make changes. In my case I just want to clean up after myself, so I'll use the distribution_id and ETag from before to disable the distribution. We need to use the ETag as well because it provides a way to refer to different versions of the same distribution and ensures we are updating the version that we think we are.

    data = cdn.put_distribution_config(
      distribution_id,
      etag,
      {
        'CustomOrigin'    => {
          'DNSName'               => 'www.example.com',
          'OriginProtocolPolicy'  => 'match-viewer'
        },
        'CallerReference' => caller_reference,
        'Enabled'         => 'false'
      }
    )

    # parse the updated etag
    etag = data.headers['ETag']

Now you just need to wait for the update to happen like before and once its disabled we can delete it:

    Fog.wait_for {
      cdn.get_distribution(distribution_id).body['Status'] ## 'Deployed'
    }
    cdn.delete_distribution(distribution_id, etag)

Thats it, now go forth and speed up some load times!
