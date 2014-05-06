require 'fog/core/collection'
require 'fog/cloudstack/models/compute/ipaddress'

module Fog
  module Compute
    class Cloudstack

      class Ipaddresses < Fog::Collection

        model Fog::Compute::Cloudstack::Ipaddress

        def all
          data = service.list_public_ip_addresses['listpublicipaddressesresponse']['publicipaddress'] || []
          load(data)
        end

      end

    end
  end
end
