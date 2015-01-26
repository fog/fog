module Fog
  module Compute
    class DigitalOcean
      class Real
        #
        # Delete a SSH public key from your account
        #
        # @see https://developers.digitalocean.com/ssh-keys
        #
        def destroy_ssh_key(id)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "ssh_keys/#{id}/destroy"
          )
        end
      end

      class Mock
        def destroy_ssh_key(id)
          response = Excon::Response.new
          response.status = 200
          if self.data[:ssh_keys].reject! { |k| k['id'] == id }
            response.body = { "status" => "OK" }
          else
            response.body = { "status" => "ERROR" }
          end
          response
        end
      end
    end
  end
end
