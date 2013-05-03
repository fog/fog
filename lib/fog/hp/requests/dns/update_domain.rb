module Fog
  module HP
    class DNS

      class Real
        def update_domain(domain_id, options)
          request(
            :body    => Fog::JSON.encode(options),
            :expects => 200,
            :method  => 'PUT',
            :path    => "domains/#{domain_id}"
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
            response.body   = domain
            response
          else
            raise Fog::HP::DNS::NotFound
          end
        end
      end
    end
  end
end