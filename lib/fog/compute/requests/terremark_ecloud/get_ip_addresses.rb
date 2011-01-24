module Fog
  module TerremarkEcloud
    class Compute
      class Real

        require 'fog/compute/parsers/terremark_ecloud/get_ip_addresses'

        def get_ip_addresses(href)
          request({
            :href       => href,
            :idempotent => true,
            :parser     => Fog::Parsers::TerremarkEcloud::Compute::GetIpAddresses.new
          })
        end

      end

      class Mock

        def get_ip_addresses(href)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
