# Examples for working with HP Cloud CDN Service

The HP Cloud services provides CDN support via the request layer abstraction.  In the request abstraction, you can CDN-enable a container, get a list of the CDN-enabled containers, list the metadata for a CDN-enabled container, update the metadata for a CDN-enabled container, and CDN-disable a container.

The examples on this page can be executed from within a Ruby console (IRB):

        irb

* [Connecting to the Service](https://github.com/fog/fog/blob/master/lib/fog/hp/docs/connect.md)


## CDN-Enabling an Existing Container

To CDN-enable an existing container:

        conn.put_container("fog-rocks")

## Listing CDN-Enabled Containers

To generate a list of CDN-enabled containers:

        conn.get_containers

## Listing the Metadata for a CDN-Enabled Container

To list the metadata (or header information) for a CDN-enabled container:

        conn.head_container("fog-rocks")

## Updating the Metadata for a CDN-Enabled Container

To update or modify the metadata for a CDN-enabled container, use the command

> conn.post_container("fog-rocks", {**option**})

Where _option_ can be any of the following:

* X-CDN-Enabled <Boolean> - cdn status for container
* X-CDN-URI <String> - cdn url for this container
* 'X-TTL'<~String> - integer seconds before data expires, defaults to 86400 (1 day), in 900 (15 min.) to 1577836800 (50 years)
* X-Log-Retention <Boolean>

So for example, if you want to modify the X-TTL metadata information so that the value becomes 3600, the command would be:

        conn.post_container("fog-rocks", {'X-Ttl' => 3600 })

## Disabling a CDN Container

To CDN-disable container:

        conn.delete_container("fog-rocks")

---------
[Documentation Home](https://github.com/fog/fog/blob/master/lib/fog/hp/README.md) | [Examples](https://github.com/fog/fog/blob/master/lib/fog/hp/examples/getting_started_examples.md)
