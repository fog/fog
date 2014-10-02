module Fog
    module Compute
        class ProfitBricks
            class Region < Fog::Model
                identity  :id,      :aliases => 'locationId'
                attribute :name,    :aliases => 'locationName'
                attribute :country, :aliases => 'country'

                def initialize(attributes={})
                    super
                end
            end
        end
    end
end