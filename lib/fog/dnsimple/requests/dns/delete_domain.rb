module Fog
  module DNS
    class DNSimple
      class Real
        # Delete the given domain from your account. You may use
        # either the domain ID or the domain name.
        #
        # Please note that for domains which are registered with
        # DNSimple this will not delete the domain from the registry.
        #
        # ==== Parameters
        # * domain<~String> - domain name or numeric ID
        #
        def delete_domain(domain)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "/domains/#{domain}"
          )
        end
      end

      class Mock
        def delete_domain(name)
          self.data[:records].delete name
          self.data[:domains].reject! { |domain| domain["domain"]["name"] == name }

          response = Excon::Response.new
          response.status = 200
          response
        end
      end
    end
  end
end
