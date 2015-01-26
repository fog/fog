module Fog
  module HP
    class DNS
      # Get details for existing DNS domain
      #
      # ==== Parameters
      # * domain_id<~String> - UUId of the domain to get
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      #     * 'id'<~String> - UUID of the domain
      #     * 'name'<~String> - Name of the domain
      #     * 'ttl'<~Integer> - TTL for the domain
      #     * 'email'<~String> - Email for the domain
      #     * 'serial'<~Integer> - Serial number for the domain
      #     * 'created_at'<~String> - created date time stamp
      class Real
        def get_domain(domain_id)
          request(
              :expects => 200,
              :method  => 'GET',
              :path    => "domains/#{domain_id}"
          )
        end
      end
      class Mock
        def get_domain(domain_id)
          response = Excon::Response.new
          if domain = list_domains.body['domains'].find { |_| _['id'] == domain_id }
            response.status = 200
            response.body = domain
            response
          else
            raise Fog::HP::DNS::NotFound
          end
        end
      end
    end
  end
end
