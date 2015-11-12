module Fog
  module Compute
    class Ovirt
      class AffinityGroup < Fog::Model
        identity :id
        
        attribute :name
        attribute :positive
        attribute :enforcing
        
        def vms
          id.nil? ? [] : service.list_affinity_group_vms(id)
        end

        def destroy
          service.destroy_affinity_group(id)
        end

        def to_s
          name
        end
      end
    end
  end
end
