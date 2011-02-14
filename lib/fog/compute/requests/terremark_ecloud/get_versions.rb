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
          })
          version_info = response.body['SupportedVersions'].detect {|version_info| version_info['Version'] == @version}
          unless @login_url = version_info && version_info['LoginUrl']
            # no LoginUrl matches specified version
            raise "TerremarkEcloud does not support version #{@version}"
          end
          response
        end

      end
    end
  end
end
