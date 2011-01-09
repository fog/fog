module Fog
  module TerremarkEcloud
    class Compute

      class Real

        require 'fog/compute/parsers/terremark_ecloud/get_organization'

        def get_organization(uri = nil)
          request({
                    :uri        => uri || organization_uri,
                    :idempotent => true,
                    :parser     => Fog::Parsers::TerremarkEcloud::Compute::GetOrganization.new
                  })
        end

      end
    end
  end
end
