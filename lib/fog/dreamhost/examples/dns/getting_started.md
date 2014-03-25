# Getting started with Fog::DNS and Dreamhost (2013/01/21)

You'll need a [Dreamhost](http://www.dreamhost.com) account and API key
to use this.

See http://wiki.dreamhost.com/API.

Create an API key selecting **'All dns functions'** to be able to add/remove/list
records.

## Create the service

We need to create the service first, using the API key from our account:

```ruby
require 'fog'
require 'pp'

dh = Fog::DNS.new( :provider => "Dreamhost",
                   :dreamhost_api_key => '6SHU5P2HLDAYECUM' )
```

## List all the DNS zones

This will list all the DNS zones avaialble in your account:

```ruby
dh.zones.each do |zone|
  puts zone.domain
end
```

## Retrieve all the records

List all the records available in your Dreamhost account, accross all the zones:

```ruby
dh.records.each do |r|
  puts r.name
end
```

If you  want to fetch all the records in a single zone:

```ruby
zone = dh.zones.get 'fog-dream.com'
zone.records.each do |r|
  # do something with the record
end
```

See http://wiki.dreamhost.com/API/Dns_commands#dns-list_records

## Retrieve a single record

Get a single record and do something with the attributes:

```ruby
rec = dh.records.get 'msn.jabber.groo.com'
rec.type       # A, CNAME, TXT, etc
rec.zone       # zone the record belongs to
rec.account_id # Dreamhost account ID
rec.comment    # Record text comment
rec.value      # record value
```

## Create a new A record

Let's create a new A record:

```
zone = dh.zones.get 'rbel.co'
zone.records.create :name => 'stuff.rbel.co',
                    :type => 'TXT',
                    :value => 'foobar bar bar'
```

Since Dreamhost API does not support the concept of zone,
you can also use this code to accomplish the same thing:

```ruby
dh.records.create(
  :name => 'stuff.rbel.co',
  :type => 'A',
  :value => '8.8.8.8'
)
```

## Destroy all the records in a zone

```ruby
(dh.zones.get 'rbel.co').records.each do |rec|
  rec.destroy
end
```

## Resources

The Dreamhost API:

http://wiki.dreamhost.com/Application_programming_interface

DNS API commands:

http://wiki.dreamhost.com/API/Dns_commands
