module Fog
  module Compute
    class Vsphere

      class Datacenter < Fog::Model

        identity :id
        attribute :name
        attribute :status

        def clusters filters = { }
          service.clusters({ :datacenter => name }.merge(filters))
        end

        def networks filters = { }
          service.networks({ :datacenter => name }.merge(filters))
        end

        def datastores filters = { }
          service.datastores({ :datacenter => name }.merge(filters))
        end

        def vm_folders filters = { }
          service.folders({ :datacenter => name, :type => :vm }.merge(filters))
        end

        def virtual_machines filters = {}
          service.servers({ :datacenter => name }.merge(filters))
        end
        
        def customfields filters = {}
          service.customfields({ :datacenter => name}.merge(filters))
        end

        def to_s
          name
        end

      end

    end
  end
end
