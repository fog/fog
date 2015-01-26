module Fog
  module DNS
    class Rage4
      class Real
        # Create a domain with a vanity name server.
        # ==== Parameters
        # * name<~String> - domain name
        # * nsname<~String> - vanity ns domain name
        # * nsprefix<~String> - prefix for the domain name, defaults to 'ns'
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #      * 'status'<~Boolean>
        #      * 'id'<~Integer>
        #      * 'error'<~String>
        def create_domain_vanity(name, nsname, options = {})
          email = options[:email] || @rage4_email
          nsprefix = options[:nsprefix] || 'ns'
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => "/rapi/createregulardomainext/?name=#{name}&email=#{email}" +
                    "&nsname=#{nsname}&nsprefix=#{nsprefix}"
          )
        end
      end
    end
  end
end
