module Fog
    module Compute
        class ProfitBricks
            class DataCenter < Fog::Model
                identity  :id
                attribute :name

                def servers filters={}
                    service.servers({ :datacenter => path.join('/') }.merge(filters))
                end 
            end
        end
    end
end
