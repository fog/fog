module Fog
  module Compute
    class OpenStack
      class Real
        # Available filters: name, status, image, flavor, changes_since, reservation_id
        def list_servers_detail(options = {})
          params = options.dup
          if params[:all_tenants]
            params['all_tenants'] = 'True'
            params.delete(:all_tenants)
          end

          request(
            :expects => [200, 203],
            :method  => 'GET',
            :path    => 'servers/detail.json',
            :query   => params
          )
        end
      end

      class Mock
        def list_servers_detail(filters = {})
          response = Excon::Response.new

          servers = self.data[:servers].values
          for server in servers
            case server['status']
            when 'BUILD'
              if Time.now - self.data[:last_modified][:servers][server['id']] > Fog::Mock.delay * 2
                server['status'] = 'ACTIVE'
              end
            end
          end

          response.status = [200, 203][rand(1)]
          response.body = { 'servers' => servers }
          response
        end
      end
    end
  end
end
