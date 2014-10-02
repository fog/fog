module Fog
    module Compute
        class ProfitBricks
            class Flavor < Fog::Model
                identity  :id,   :aliases => 'flavorId'
                attribute :name, :aliases => 'flavorName'
                attribute :cores
                attribute :ram

                def initialize(attributes={})
                    super
                end

                def save
                    requires :name, :ram, :cores
                    data = service.create_flavor(name, cores, ram)
                    merge_attributes(data.body['createFlavorResponse'])
                    true
                end

                def update
                    Fog::Mock.not_implemented
                end
            end
        end
    end
end