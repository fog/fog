module Fog
  module TerremarkEcloud
    class Compute
      class Real

        require 'fog/compute/parsers/terremark_ecloud/get_ip_address'

        def get_ip_address(href)
          request({
            :href       => href,
            :idempotent => true,
            :parser     => Fog::Parsers::TerremarkEcloud::Compute::GetIpAddress.new
          })
        end

      end
    end
  end
end
