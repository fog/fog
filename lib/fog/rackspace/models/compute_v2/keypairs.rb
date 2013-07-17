require 'fog/core/collection'
require 'fog/rackspace/models/compute_v2/keypair'

module Fog
  module Compute
    class RackspaceV2

      class Keypairs < Fog::Collection

        model Fog::Compute::RackspaceV2::Keypair

        def all
          data = []
          service.list_keypairs.body['keypairs'].each do |kp|
            data << kp['keypair'] if kp['keypair']
          end
          load(data)
        end

        def get(key_id)
          begin
            new(service.get_keypair(key_id).body['keypair'])
          rescue Fog::Compute::Rackspace::NotFound
            nil
          end
        end

      end
    end
  end
end
