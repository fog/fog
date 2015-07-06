require 'fog/core/collection'
require 'fog/openstack/models/volume/transfer'

module Fog
  module Volume
    class OpenStack
      class Transfers < Fog::Collection
        model Fog::Volume::OpenStack::Transfer

        def all(options = {})
          load(service.list_transfers_detailed(options).body['transfers'])
        end

        def summary(options = {})
          load(service.list_transfers(options).body['transfers'])
        end

        def get(transfer_id)
          if transfer = service.get_transfer_details(transfer_id).body['transfer']
            new(transfer)
          end
        rescue Fog::Volume::OpenStack::NotFound
          nil
        end
        alias_method :find_by_id, :get

        def accept(transfer_id, auth_key)
          # NOTE: This is NOT a method on the Transfer object, since the
          # receiver cannot see the transfer object in the get_transfer_details
          # or list_transfers(_detailed) requests.
          if transfer = service.accept_transfer(transfer_id, auth_key).body['transfer']
            new(transfer)
          end
        end

      end
    end
  end
end
