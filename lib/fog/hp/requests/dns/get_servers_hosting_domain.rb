module Fog
  module HP
    class DNS
      class Real
        # Get authoritative nameservers for existing DNS domain
        #
        # ==== Parameters
        # * domain_id<~String> - UUId of the domain to get nameservers for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'nameservers'<~Array>:
        #       * 'id'<~String> - UUID of the domain
        #       * 'name'<~String> - Name of the domain
        #       * 'ttl'<~Integer> - TTL for the domain
        #       * 'email'<~String> - Email for the domain
        #       * 'serial'<~Integer> - Serial number for the domain
        #       * 'created_at'<~String> - created date time stamp
        def get_servers_hosting_domain(domain_id)
          request(
              :expects => 200,
              :method  => 'GET',
              :path    => "domains/#{domain_id}/servers"
          )
        end
      end

      class Mock
        def get_servers_hosting_domain(domain_id)
          response = Excon::Response.new
          if list_domains.body['domains'].find { |_| _['id'] == domain_id }
            response.status = 200
            response.body   = { 'servers' => dummy_servers }
            response
          else
            raise Fog::HP::DNS::NotFound
          end
        end

        def dummy_servers
          [
              {
                  'id'         => Fog::HP::Mock.uuid.to_s,
                  'name'       => 'ns1.provider.com.',
                  'created_at' => '2012-01-01T13:32:20Z',
                  'updated_at' => '2012-01-01T13:32:20Z'
              },
              {
                  'id'         => Fog::HP::Mock.uuid.to_s,
                  'name'       => 'ns2.provider.com.',
                  'created_at' => '2012-01-01T13:32:20Z',
                  'updated_at' => '2012-01-01T13:32:20Z'
              },
          ]
        end
      end
    end
  end
end
