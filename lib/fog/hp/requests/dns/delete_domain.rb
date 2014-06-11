module Fog
  module HP
    class DNS
      class Real
        # Delete a DNS domain
        #
        # ==== Parameters
        # * domain_id<~String> - UUId of domain to delete
        #
        def delete_domain(domain_id)
          request(
              :expects => 200,
              :method  => 'DELETE',
              :path    => "domains/#{domain_id}"
          )
        end
      end

      class Mock
        def delete_domain(domain_id)
          response = Excon::Response.new
          if list_domains.body['domains'].find { |_| _['id'] == domain_id }
            response.status = 202
            response
          else
            raise Fog::HP::DNS::NotFound
          end
        end
      end
    end
  end
end
