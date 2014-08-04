require 'fog/core/collection'
require 'fog/profitbricks/models/compute/interface'

module Fog
    module Compute
        class ProfitBricks
            class Interfaces < Fog::Collection
                model Fog::Compute::ProfitBricks::Interface

                def all
                    load(service.get_all_nic.body['getAllNicResponse'])
                end

                def get(id)
                    interface = service.get_nic(id).body['getNicResponse']
                    Excon::Errors
                    new(interface)
                rescue Excon::Errors::NotFound
                    nil
                end

                def set_internet_access
                    require :data_center_id, :lan_id, :internet_access
                    service.set_internet_access(data_center_id, lan_id, internet_access)
                end
            end
        end
    end
end