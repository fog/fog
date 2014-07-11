require 'fog/core/collection'
require 'fog/profitbricks/models/compute/data_center'

module Fog
    module Compute
        class ProfitBricks
            class DataCenters < Fog::Collection
                model Fog::Compute::ProfitBricks::DataCenter

                #identity :id, :dataCenterId.

                #attribute :id,      :aliases => 'dataCenterId',    :type => :string
                #attribute :name,    :aliases => 'dataCenterName',  :type => :string

                #service.get_all_data_centers.body['getAllDataCentersResponse']


                def all(filters = {})
                    load (service.get_all_data_centers.body['getAllDataCentersResponse'])
                    #service.get_all_data_centers.body['getAllDataCentersResponse']
                end

                def get(data_center_id)
                    data_center = service.get_data_center(data_center_id).body['getDataCenterResponse']
                    new(data_center)
                rescue Excon::Errors::NotFound
                    nil
                end
            end
        end
    end
end
