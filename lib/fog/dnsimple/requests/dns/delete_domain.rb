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
        # * name<~String> - domain name or numeric ID
        #
        def delete_domain(name)
          request(
                  :expects  => 200,
                  :method   => 'DELETE',
                  :path     => "/domains/#{name}"
                  )
        end

      end
    end
  end
end
