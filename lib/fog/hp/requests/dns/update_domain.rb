module Fog
  module HP
    class DNS

      class Real
        # Update an existing DNS domain
        #
        # ==== Parameters
        # * domain_id<~String> - UUId of domain to delete
        # * options<~Hash>:
        #   * 'name'<~String> - Name of domain
        #   * 'ttl'<~String> - TTL for the domain
        #   * 'email'<~String> - email for the domain
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
        def update_domain(domain_id, options={})
          l_options = [:name, :ttl, :email]
          l_options.select{|o| options[o]}.each do |key|
            data[key] = options[key]
          end

          request(
            :body    => Fog::JSON.encode(data),
            :expects => 200,
            :method  => 'PUT',
            :path    => "domains/#{domain_id}"
          )
        end
      end

      class Mock
        def update_domain(domain_id, options={})
          response = Excon::Response.new
          if domain = list_domains.body['domains'].detect { |_| _['id'] == domain_id }

            domain['name']  = options[:name]   if options[:name]
            domain['ttl']   = options[:ttl]    if options[:ttl]
            domain['email'] = options[:email]  if options[:email]

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