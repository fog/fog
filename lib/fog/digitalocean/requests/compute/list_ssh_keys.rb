module Fog
  module Compute
    class DigitalOcean 
      class Real

        def list_ssh_keys(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'ssh_keys'
          )
        end

      end

      class Mock

        def list_ssh_keys
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "status" => "OK",
            # key listing does not return ssh_pub_key
            # https://www.digitalocean.com/api#ssh_keys
            "ssh_keys"  => self.data[:ssh_keys].map { |k| k.delete('ssh_pub_key'); k }
          }
          response
        end

      end
    end
  end
end
