module Fog
  module HP
    class DNS

      class Real
        def update_domain(domain_id,options)
          request(
              :body    => MultiJson.encode(options),
              :expects => 200,
              :method  => 'PUT',
              :path    => "servers/#{server_id}.json"
          )

        end
      end

      class Mock
        def update_domain(domain_id, options)
          response = Excon::Response.new
          if domain = list_domains.body['domains'].detect { |_| _['id'] == domain_id }
            if options['name']
              domain['name'] = options['name']
            end
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