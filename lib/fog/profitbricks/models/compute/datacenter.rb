module Fog
    module Compute
        class ProfitBricks
            class Datacenter < Fog::Model
                identity  :id,         :aliases => 'dataCenterId'
                attribute :name,       :aliases => 'dataCenterName'
                attribute :version,    :aliases => 'dataCenterVersion'
                attribute :state,      :aliases => 'provisioningState'
                attribute :request_id, :aliases => 'requestId'
                attribute :region

                def initialize(attributes={})
                    super
                end

                def save
                    requires :name
                    data = service.create_data_center(name, region)
                    merge_attributes(data.body['createDataCenterResponse'])
                    true
                end

                def update
                    requires :id, :name
                    data = service.update_data_center(id, name)
                    merge_attributes(data.body['updateDataCenterResponse'])
                    true
                end

                def destroy
                    requires :id
                    service.delete_data_center(id)
                    true
                end

                def ready?
                    self.state == 'AVAILABLE'
                end

                def failed?
                    self.state == 'ERROR'
                end
            end
        end
    end
end
