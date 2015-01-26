module Fog
  module DNS
    class Rage4
      class Real
        # Get the details for a specific domain in your account.
        # ==== Parameters
        # * name<~String> - name of domain
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #      * 'id'<~Integer>
        #      * 'name'<~String>
        #      * 'owner_email'<~String>
        #      * 'type'<~Integer>
        #      * 'subnet_mask'<~Integer>
        def get_domain_by_name(name)
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => "/rapi/getdomainbyname/?name=#{name}")
        end
      end
    end
  end
end
