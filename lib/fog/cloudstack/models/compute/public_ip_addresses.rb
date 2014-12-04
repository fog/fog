require 'fog/core/collection'
require 'fog/cloudstack/models/compute/address'

module Fog
  module Compute
    class Cloudstack
      class PublicIpAddresses < Fog::Collection
        model Fog::Compute::Cloudstack::PublicIpAddress

        def all(options = {})
          response = service.list_public_ip_addresses(options)
          public_ip_addresses = response["listpublicipaddressesresponse"]["publicipaddress"] || []
          load(public_ip_addresses)
        end

        def get(address_id)
          options = { 'id' => address_id }
          response = service.list_public_ip_addresses(options)
          public_ip_addresses = response["listpublicipaddressesresponse"]["publicipaddress"].first
          new(public_ip_addresses)
        end
      end
    end
  end
end
