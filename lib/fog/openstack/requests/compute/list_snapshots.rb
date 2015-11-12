module Fog
  module Compute
    class OpenStack
      class Real
        def list_snapshots(options = true)
          if options.is_a?(Hash)
            path = 'os-snapshots'
            query = options
          else
            # Backwards compatibility layer, when 'detailed' boolean was sent as first param
            if options
              Fog::Logger.deprecation('Calling OpenStack[:compute].list_snapshots(true) is deprecated, use .list_snapshots_detail instead')
            else
              Fog::Logger.deprecation('Calling OpenStack[:compute].list_snapshots(false) is deprecated, use .list_snapshots({}) instead')
            end
            path = options ? 'os-snapshots/detail' : 'os-snapshots'
            query = {}
          end

          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => path,
            :query    => query
          )
        end
      end

      class Mock
        def list_snapshots(options = true)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'snapshots' => [get_snapshot_details.body["snapshot"]]
          }
          response
        end
      end
    end
  end
end
