require 'fog/digitalocean/models/compute/ssh_key'

module Fog
  module Compute
    class DigitalOcean 
      class SshKeys < Fog::Collection

        identity :href

        model Fog::Compute::DigitalOcean::SshKey

        def all
          data = service.list_ssh_keys.body['ssh_keys']
          load(data)
        end

        def get(uri)
          if data = service.get_ssh_key(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
