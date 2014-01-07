require 'fog/core/collection'
require 'fog/cloudstack/models/compute/key_pair'

module Fog
  module Compute
    class Cloudstack

      class KeyPairs < Fog::Collection

        model Fog::Compute::Cloudstack::KeyPair

        def all
          data = service.list_ssh_key_pairs["listsshkeypairsresponse"]["sshkeypair"] || []
          load(data)
        end

        def get(key_pair_name)
          if key_pair_name
            self.all.select {|kp| kp.name == key_pair_name}.first
          end
        rescue Fog::Compute::CloudStack::NotFound
          nil
        end

      end
    end
  end
end
