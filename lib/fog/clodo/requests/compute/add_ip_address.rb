module Fog
  module Compute
    class Clodo
      class Real
        # Bye new IP-address for specified server
        # ==== Paramaters
        # * server_id<~Integer> - Id of server to bye IP for
        #
        # ==== Returns
        # * response<~Excon::Response>
        #

        def add_ip_address(server_id)
          request(
                  :expects  => [204],
                  :method   => 'PUT',
                  :path     => "servers/#{server_id}/ips"
                  )
        end
      end

      class Mock
        def add_ip_address(server_id)
          raise Excon::Errors::BadRequest.new(
                                              "Invalid image ID"
                                              ) unless server_id > 0

          data = {
            'primary_ip' => false,
            'isp' => false,
            'ip' => "66.6.#{rand(255)}.#{rand(255)}"
          }

          raise Excon::Errors::BadRequest unless self.data[:servers][server_id]

          raise Excon::Errors::BadRequest.new "No addresses" unless self.data[:servers][server_id]['addresses']

          self.data[:servers][server_id]['addresses']['public'] << data

          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
