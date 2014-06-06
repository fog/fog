module Fog
  module DNS
    class Rage4
      class Real
        # Create a reverse domain for an ipv4 address .
        # ==== Parameters
        # * name<~String> - expects an ipv5 address
        # * subnet<~Integer> - subnet ie: 9 for /9, range is /8 to /30
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #      * 'status'<~Boolean>
        #      * 'id'<~Integer>
        #      * 'error'<~String>
        def create_reverse_domain_4(name, subnet, options = {})
          email = options[:email] || @rage4_email
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => "/rapi/createreversedomain4/?name=#{name}&email=#{email}" +
                    "&subnet=#{subnet}"
          )
        end
      end
    end
  end
end
