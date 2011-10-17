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
                  :body     => MultiJson.encode(body),
                  :expects  => 201,
                  :method   => 'POST',
                  :path     => '/domains'
                  )
        end

      end
    end
  end
end
