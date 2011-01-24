module Fog
  module TerremarkEcloud
    class Compute
      class Real

        require 'fog/compute/parsers/terremark_ecloud/get_organization'

        def get_organization(href = organization_href)
          request({
            :href       => href,
            :idempotent => true,
            :parser     => Fog::Parsers::TerremarkEcloud::Compute::GetOrganization.new
          })
        end

      end

      class Mock

        def get_organization(href = organization_href)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
