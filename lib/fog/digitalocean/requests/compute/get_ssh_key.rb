module Fog
  module Compute
    class DigitalOcean
      class Real
        #
        # This method shows a specific public SSH key in your account
        # that can be added to a droplet.
        #
        # @see https://developers.digitalocean.com/ssh-keys
        #
        def get_ssh_key(id)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "ssh_keys/#{id}"
          )
        end
      end

      class Mock
        def get_ssh_key(id)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "status" => "OK",
            # key listing does not return ssh_pub_key
            # https://developers.digitalocean.com/ssh-keys
            "ssh_key"  => self.data[:ssh_keys].find { |k| k['id'] == id }
          }
          response
        end
      end
    end
  end
end
