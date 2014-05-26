module Fog
  module DNS
    class DNSimple
      class Real
        # Get the details for a specific domain in your account. You
        # may pass either the domain numeric ID or the domain name
        # itself.
        #
        # ==== Parameters
        # * domain<~String> - domain name or numeric ID
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'domain'<~Hash> The representation of the domain.
        def get_domain(domain)
          request(
            :expects  => 200,
            :method   => "GET",
            :path     => "/domains/#{domain}"
          )
        end
      end

      class Mock
        def get_domain(id)
          domain = self.data[:domains].find do |domain|
            domain["domain"]["id"] == id || domain["domain"]["name"] == id
          end

          response = Excon::Response.new
          response.status = 200
          response.body = domain
          response
        end
      end
    end
  end
end
