module Fog
  module DNS
    class Rage4
      class Real
        # Create a domain.
        # ==== Parameters
        # * name<~String> - domain name
        # * email<~String> - email of owner of domain, defaults to email of credentials
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #      * 'status'<~Boolean>
        #      * 'id'<~Integer>
        #      * 'error'<~String>
        #

        def create_domain(name, options = {})
          email = options[:email] || @rage4_email
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => "/rapi/createregulardomain/?name=#{name}&email=#{email}"
          )
        end
      end
    end
  end
end
