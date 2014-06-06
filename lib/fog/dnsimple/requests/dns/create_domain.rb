module Fog
  module DNS
    class DNSimple
      class Real
        # Create a single domain in DNSimple in your account.
        #
        # ==== Parameters
        # * name<~String> - domain name to host (ie example.com)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'domain'<~Hash> The representation of the domain.
        def create_domain(name)
          body = {
            "domain" => {
              "name" => name
            }
          }

          request(
            :body     => Fog::JSON.encode(body),
            :expects  => 201,
            :method   => 'POST',
            :path     => "/domains"
          )
        end
      end

      class Mock
        def create_domain(name)
          body = {
            "domain" =>  {
              "id"                 => Fog::Mock.random_numbers(1).to_i,
              "user_id"            => 1,
              "registrant_id"      => nil,
              "name"               => name,
              "unicode_name"       => name,
              "token"              => "4fIFYWYiJayvL2tkf_mkBkqC4L+4RtYqDA",
              "state"              => "registered",
              "language"           => nil,
              "lockable"           => true,
              "auto_renew"         => nil,
              "whois_protected"    => false,
              "record_count"       => 0,
              "service_count"      => 0,
              "expires_on"         => Date.today + 365,
              "created_at"         => Time.now.iso8601,
              "updated_at"         => Time.now.iso8601,
            }
          }
          self.data[:domains] << body

          response = Excon::Response.new
          response.status = 201
          response.body = body
          response
        end
      end
    end
  end
end
