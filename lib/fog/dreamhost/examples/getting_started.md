# Getting started with Fog::DNS and Dreamhost (2013/01/21)

You'll need a [Dreamhost](http://www.dreamhost.com) account and API key 
to use this.

See http://wiki.dreamhost.com/API.

Create an API key selecting **'All dns functions'** to be able to add/remove/list
records.

## Create the service

We need to create the service first, using the key we added:

```ruby
require 'fog' 
require 'pp'

dh = Fog::DNS.new( :provider => "Dreamhost",
                   :dreamhost_api_key => '6SHU5P2HLDAYECUM'
                  )
```

## Retrieve all the records

List all the records available to your Dreamhost account, accross all the zones:

```ruby
dh.records.all.each do |r|
  puts r.name
end
```

See http://wiki.dreamhost.com/API/Dns_commands#dns-list_records

## Fetch a single record

We can only retrieve a single record, if that's what we need. Then,
read some of the attributes:

```ruby
rec = dh.records.get 'msn.jabber.groo.com'
rec.type       # A, CNAME, TXT, etc
rec.zone       # zone the record belongs to
rec.account_id # Dreamhost account ID
rec.comment    # Record text comment
rec.value      # record value
```

## Fetch all the records from zone foobar.com

```ruby
zone = dh.zones.get 'foobar.com'
zone.records
```

## Create a new A record

```ruby
dh.records.create(
  :name => 'stuff.rbel.co', 
  :type => 'A',
  :value => '8.8.8.8'
)
```

You can also use the following code, similar to other fog providers:

```
zone = dh.zones.get 'foobar.com'
zone.records.create :name => 'stuff.rbel.co',
                    :type => 'TXT',
                    :value => 'foobar bar bar'
```


## Destroy all the records in a zone

```ruby
(dh.zones.get 'foobar.com').each do |rec|
  rec.destroy
end
```
