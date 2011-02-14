module Fog
  module TerremarkEcloud
    class Compute
      class Real

        require 'fog/compute/parsers/terremark_ecloud/get_versions'

        def get_versions
          connection = Fog::Connection.new(@versions_endpoint)
          response = connection.request({
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::TerremarkEcloud::Compute::GetVersions.new
          });
        end

      end
    end
  end
end
