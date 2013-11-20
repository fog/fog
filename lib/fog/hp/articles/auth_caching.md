#Using Authentication Caching for HP Cloud Services#

Your application can run up to 40% faster if you cache the authentication information.  The authentication token is typically valid for a day or more and if you save it in a safe place, you can reuse it.  If you pass the authentication information to Fog, it does not have to reauthenticate.

For example if you save your credentials:

    @storage = Fog::Storage.new(options)
    @credentials = @storage.credentials

The next time you go to create a storage connection, pass in the credentials:

    options[:credentials] = @credentials
    @storage = Fog::Storage.new(options)
    @credentials = @storage.credentials

It is best to always update your cached credentials.  If they expire, they are automatically updated.  When you create the new connection with the credentials, you should still pass in your normal authentication information in the options.

The contents of the credentials should be treated like a set of data.  The contents of this object are likely to change in the future.

The same credentials may be used to create connections for Compute, Object Storage, CDN, Block Storage, and other services.

---------
[Documentation Home](https://github.com/fog/fog/blob/master/lib/fog/hp/README.md) | [Examples](https://github.com/fog/fog/blob/master/lib/fog/hp/examples/getting_started_examples.md)
