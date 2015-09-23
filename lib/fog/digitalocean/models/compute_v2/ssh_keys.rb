module Fog
  module Compute
    class DigitalOceanV2
      class SshKeys < Fog::Collection
        model Fog::Compute::DigitalOceanV2::SshKey

        def all(filters={})
          data = service.list_ssh_keys.body['ssh_keys']
          load(data)
        end

        def get(id)
          key = service.get_ssh_key(id).body['ssh_key']
          new(key) if key
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end