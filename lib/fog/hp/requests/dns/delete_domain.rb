module Fog
  module HP
    class DNS

      class Real

        # Delete a Domain
        #
        # ==== Parameters
        # * domain_id<~Integer> - Id of domain to delete
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
          if image = find_domain(domain_id)
            response.status = 202
            response
          else
            response.status = 404
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end

        def find_domain(domain_id)
          list_domains.body['domains'].detect { |_| _['id'] == domain_id }
        end

      end

    end
  end
end