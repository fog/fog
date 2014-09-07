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

                attr_accessor :options

                def initialize(attributes={})
                    super
                end

                def save
                    requires :name, :region

                    data = service.create_data_center(name, region)
                    merge_attributes(data.body['createDataCenterResponse'])
                    true
                end

                def update
                    requires :id
                    data = service.update_data_center(id, options)
                    merge_attributes(data.body['updateDataCenterResponse'])
                    true
                end

                def destroy
                    requires :id
                    service.delete_data_center(id)
                    true
                end

                def clear(confirm = false)
                    requires :id
                    if confirm == true
                        service.clear_data_center(id)
                        true
                    else
                        raise ArgumentError.new('Confirm with true boolean to clear datacenter')
                    end
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
