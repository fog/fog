module Fog
  module HP
    class DNS
        # Create a new DNS domain
        #
        # ==== Parameters
        # * 'name'<~String> - Name of the domain
        # * 'email'<~String> - Email for the domain
        # * options<~Hash>:
        #   * 'description'<~String> - Description for the domain
        #   * 'ttl'<~String> - TTL for the domain
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'id'<~String> - UUID of the domain
        #     * 'name'<~String> - Name of the domain
        #     * 'description'<~String> - Description for the domain
        #     * 'ttl'<~Integer> - TTL for the domain
        #     * 'email'<~String> - Email for the domain
        #     * 'serial'<~Integer> - Serial number for the domain
        #     * 'created_at'<~String> - created date time stamp
      class Real
        def create_domain(name, email, options={})
          data = {
            :name => name,
            :email => email
          }

          l_options = [:description, :ttl]
          l_options.select{|o| options[o]}.each do |key|
            data[key] = options[key]
          end

          request(
              :body    => Fog::JSON.encode(data),
              :expects => 200,
              :method  => 'POST',
              :path    => 'domains'
          )
        end
      end

      class Mock
        def create_domain(name, email, options={})
          response        = Excon::Response.new
          response.status = 200

          data = {
              'id'         => Fog::HP::Mock.uuid.to_s,
              'name'       => name || 'domain1.com.',
              'email'      => email || 'nsadmin@example.org',
              'description' => options[:description] || 'desc domain1.com.',
              'ttl'        => options[:ttl] || 3600,
              'serial'     => Fog::Mock.random_numbers(10).to_i,
              'created_at' => '2012-01-01T13:32:20Z'
          }
          self.data[:domains][data['id']] = data
          response.body = data
          response
        end
      end
    end
  end
end
