module Fog
  module HP
    class DNS

      # Get details for existing domain
      #
      # ==== Parameters
      # * instance_id<~Integer> - Id of the domain to get
      #
      # ==== Returns
      # * response<~Excon::Response>:
      # *TBD
      class Real
        def get_domain(instance_id)
          response = request(
              :expects => 200,
              :method  => 'GET',
              :path    => "domains/#{instance_id}",
          )
          response
        end
      end
      class Mock

        def get_domain(instance_id)
          response = Excon::Response.new
          if domain = find_domain(instance_id)
            response.status = 200
            response.body = {'domain' => domain}
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