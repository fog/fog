module Fog
    module Compute
        class ProfitBricks
            class Flavor < Fog::Model
                identity  :id
                attribute :name
                attribute :ram
                attribute :disk
                attribute :cores

                def initialize(attributes={})
                    super
                end

                def save
                    requires :name, :ram, :disk, :cores
                    data = service.create_flavor(name, ram, disk, cores)
                    merge_attributes(data.body['createFlavorResponse'])
                    true
                end

                def update
                    true
                end
            end
        end
    end
end