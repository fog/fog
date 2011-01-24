module Fog
  module TerremarkEcloud
    class Compute
      class Real

        require 'fog/compute/parsers/terremark_ecloud/get_catalog'

        def get_catalog(href)
          request({
            :href       => href,
            :idempotent => true,
            :parser     => Fog::Parsers::TerremarkEcloud::Compute::GetCatalog.new
          })
        end

      end

      class Mock

        def get_catalog(href)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
