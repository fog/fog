module Fog
  module TerremarkEcloud
    class Compute
      class Real

        require 'fog/compute/parsers/terremark_ecloud/get_vdc'

        def get_vdc(href)
          request({
            :href       => href,
            :idempotent => true,
            :parser     => Fog::Parsers::TerremarkEcloud::Compute::GetVdc.new
          })
        end

      end

      class Mock

        def get_vdc
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
