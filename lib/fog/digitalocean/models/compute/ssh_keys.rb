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
          data = service.get_ssh_key(uri).body['ssh_key']
          new(data)
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
