module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_ssh_key
      end

      class Mock
        def get_ssh_key(uri)
          ssh_key_id = id_from_uri(uri).to_i
          ssh_key    = self.data[:ssh_keys][ssh_key_id.to_i]

          if ssh_key
            response(:body => Fog::Ecloud.slice(ssh_key, :id, :admin_organization))
          else response(:status => 404) # ?
          end
        end
      end
    end
  end
end
