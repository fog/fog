module Fog
  module DNS
    class Rage4
      class Real

        # Import a domain. You need to allow AXFR transfers.
        # Only regular domains are supported.
        # ==== Parameters
        # * name<~String> - name of the domain
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #      * 'status'<~Boolean>
        #      * 'id'<~Integer>
        #      * 'error'<~String>
        def import_domain(name)
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => "/rapi/importdomain/#{name}" )

        end

      end

    end
  end
end
