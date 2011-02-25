module Fog
  module DNSimple
    class DNS
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
                  :body     => body.to_json,
                  :expects  => 201,
                  :method   => 'POST',
                  :path     => '/domains'
                  )
        end

      end
    end
  end
end
