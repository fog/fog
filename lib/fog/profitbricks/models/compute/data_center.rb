#require 'fog/compute/models/data_center'

module Fog
    module Compute
        class ProfitBricks
            class DataCenter < Fog::Model
                identity  :id,         :aliases => 'dataCenterId'
                attribute :name,       :aliases => 'dataCenterName'
                attribute :version,    :aliases => 'dataCenterVersion'
                attribute :state,      :aliases => 'provisioningState'
                attribute :request_id, :aliases => 'requestId'
                attribute :region

                #{"requestId"=>"3343852", "dataCenterId"=>"6571ecd4-8602-4692-ae14-2f85eedbc403", "dataCenterVersion"=>1, "dataCenterName"=>"abc", "provisioningState"=>"AVAILABLE", "region"=>"NORTH_AMERICA"}

                def initialize(attributes={})
                    super
                end

                def destroy
                    requires :id
                    service.delete_data_center(id)
                    true
                end

                def ready?
                    self.state == 'ACTIVE'
                end
            end
        end
    end
end
