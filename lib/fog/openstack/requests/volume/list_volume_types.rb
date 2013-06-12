module Fog
  module Volume
    class OpenStack

      class Real
        def list_volume_types(filters = {})
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'types',
            :query   => filters
          )
        end
      end

      class Mock
        def list_volume_types(filters = {})
          Excon::Response.new(
            :body   => { 'volume_types' => self.data[:volume_types].values },
            :status => 200
          )
        end
      end

    end
  end
end