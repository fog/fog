module Fog
  module HP
    class DNS
      class Real
        # Get servers for existing domain
        #
        # ==== Parameters
        # * instance_id<~Integer> - Id of the domain with servers
        #
        # ==== Returns
        # * response<~Excon::Response>:
        # *TBD
        def get_servers_hosting_domain(instance_id)
          request(
              :expects => [200, 203],
              :method  => 'GET',
              :path    => "domains/#{instance_id}/servers"
          )
        end

      end

      class Mock

        def get_servers_hosting_domain(instance_id)
          if domain = find_domain(instance_id)
            response.status = 200
            response.body   = {'domain' => domain}
            response
          else
            response.status = 400
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end

      end
    end
  end
end
