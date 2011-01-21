module Fog
  module TerremarkEcloud
    class Compute
      class Real

        require 'fog/compute/parsers/terremark_ecloud/get_network'

        def get_network(href)
          request({
            :href       => href,
            :idempotent => true,
            :parser     => Fog::Parsers::TerremarkEcloud::Compute::GetNetwork.new
          })
        end

      end

      class Mock

        def get_network(href)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
