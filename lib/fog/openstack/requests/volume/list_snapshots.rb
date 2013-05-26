module Fog
  module Volume
    class OpenStack

      class Real
        def list_snapshots(detailed = true, filters = {})
          path = detailed ? 'snapshots/detail' : 'snapshots'
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => path,
            :query   => filters
          )
        end
      end

      class Mock
        def list_snapshots(detailed = true, filters = {})
          Excon::Response.new(
            :body   => { 'snapshots' => self.data[:snapshots].values },
            :status => 200
          )
        end
      end

    end
  end
end