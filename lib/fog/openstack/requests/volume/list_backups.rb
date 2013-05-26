module Fog
  module Volume
    class OpenStack
      
      class Real
        def list_backups(detailed = true, filters = {})
          path = detailed ? 'backups/detail' : 'backups'
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => path,
            :query   => filters
          )
        end
      end

      class Mock
        def list_backups(detailed = true, filters = {})
          Excon::Response.new(
            :body   => { 'backups' => self.data[:backups].values },
            :status => 200
          )
        end
      end

    end
  end
end