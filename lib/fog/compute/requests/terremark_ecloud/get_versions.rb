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
          version_info = response.body['SupportedVersions'].detect {|version_info| version_info['Version'] == @version}
          unless login_url = version_info && version_info['LoginUrl']
            raise "TerremarkEcloud does not support version #{@version}"
          end
        end

      end

      class Mock

        def get_versions
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
