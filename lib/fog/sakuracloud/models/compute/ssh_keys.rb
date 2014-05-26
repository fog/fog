require 'fog/core/collection'
require 'fog/sakuracloud/models/compute/ssh_key'

module Fog
  module Compute
    class SakuraCloud
      class SshKeys < Fog::Collection
        model Fog::Compute::SakuraCloud::SshKey

        def all
          load service.list_ssh_keys.body['SSHKeys']
        end

        def get(id)
          all.find { |f| f.id == id }
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
