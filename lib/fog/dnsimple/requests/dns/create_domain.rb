module Fog
  module DNS
    class DNSimple
      class Real

        # Create a single domain in DNSimple in your account.
        # ==== Parameters
        # * name<~String> - domain name to host (ie example.com)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'name'<~String>
        def create_domain(name)
          body = { "domain" => { "name" => name } }
          request(
                  :body     => Fog::JSON.encode(body),
                  :expects  => 201,
                  :method   => 'POST',
                  :path     => '/domains'
                  )
        end

      end

      class Mock

        def create_domain(name)
          response = Excon::Response.new
          response.status = 201

          body = {
            "domain" =>  {
              "auto_renew"         => nil,
              "created_at"         => Time.now.iso8601,
              "expires_on"         => Date.today + 365,
              "id"                 => Fog::Mock.random_numbers(1).to_i,
              "language"           => nil,
              "lockable"           => true,
              "name"               => name,
              "name_server_status" => "unknown",
              "registrant_id"      => nil,
              "state"              => "registered",
              "token"              => "4fIFYWYiJayvL2tkf_mkBkqC4L+4RtYqDA",
              "unicode_name"       => name,
              "updated_at"         => Time.now.iso8601,
              "user_id"            => 1,
              "record_count"       => 0,
              "service_count"      => 0,
              "private_whois?"     => false
            }
          }
          self.data[:domains] << body

          response.body = body
          response
        end

      end

    end
  end
end
