module Fog
    module Compute
        class ProfitBricks
            class Flavor < Fog::Model
                identity  :id,   :aliases => 'flavorId'
                attribute :name, :aliases => 'flavorName'
                attribute :cores
                attribute :ram
                attribute :disk

                def initialize(attributes={})
                    super
                end

                def save
                    requires :name, :ram, :disk, :cores
                    data = service.create_flavor(name, cores, ram, disk)
                    merge_attributes(data.body['createFlavorResponse'])
                    true
                end

                #def update
                #    true
                #end
            end
        end
    end
end