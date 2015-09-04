require "fog/glesys/models/compute/ssh_key"

module Fog
  module Compute
    class Glesys
      class SshKeys < Fog::Collection
        model Fog::Compute::Glesys::SshKey

        def all
          data = service.ssh_key_list.body["response"]["sshkeys"]
          load(data)
        end

        def get(id)
          hash = service.ssh_key_list.body["response"]["sshkeys"].find{|a| a["id"] == id}
          hash.nil? ? nil : new(hash)
        end
      end
    end
  end
end
