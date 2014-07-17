module Fog
    module Compute
        class ProfitBricks
            class Region < Fog::Model
                identity  :id,   :aliases => 'regionId'
                attribute :name, :aliases => 'regionName'

                def initialize(attributes={})
                    super
                end
            end
        end
    end
end