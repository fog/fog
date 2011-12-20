require 'rubygems'
require 'shindo'

require File.join(File.dirname(__FILE__), '..', 'lib', 'fog')
require File.join(File.dirname(__FILE__), '..', 'tests', 'helper')

Shindo.tests('dns examples', 'dns') do

  # iterate over all the providers
  Fog.providers.values.each do |provider|

    provider = eval(provider) # convert from string to object

    # skip if provider does not have storage
    next unless provider.respond_to?(:services) && provider.services.include?(:dns)

    tests(provider, provider.to_s.downcase) do

      # use shortcuts to instantiate connection
      @dns = Fog::DNS.new(:provider => provider.to_s)

      # create a zone
      #   domain should be the hostname
      #   email is only required for linode, but included for consistency
      tests('@zone = @dns.zones.create').succeeds do
        @zone = @dns.zones.create(
          :domain => 'fogdnsexamples.com',
          :email => 'tests@fogdnsexamples.com'
        )
      end

      # create a record in the zone
      #   ip is the address to route to
      #   name is the name for the record
      #   type is the type of record to create
      tests('@record = @zone.records.create').succeeds do
        @record = @zone.records.create(
          :value  => '1.2.3.4',
          :name   => 'www.fogdnsexamples.com',
          :type   => 'A'
        )
      end

      # list zones
      tests('@zones = @dns.zones').succeeds do
        @zones = @dns.zones
      end

      # get a zone
      tests('@dns.zones.get(@zone.identity)').succeeds do
        @dns.zones.get(@zone.identity)
      end

      # list records
      tests('@records = @zone.records').succeeds do
        @records = @zone.records
      end

      # get a record
      tests('@zone.records.get(@record.identity)').succeeds do
        @zone.records.get(@record.identity)
      end

      # destroy the record
      tests('@record.destroy').succeeds do
        @record.destroy
      end

      # destroy the zone
      tests('@zone.destroy').succeeds do
        @zone.destroy
      end

    end

  end

end
