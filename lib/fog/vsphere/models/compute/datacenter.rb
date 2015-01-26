module Fog
  module Compute
    class Vsphere
      class Datacenter < Fog::Model
        identity :id
        attribute :name
        attribute :path
        attribute :status

        def clusters filters = { }
          service.clusters({ :datacenter => path.join("/") }.merge(filters))
        end

        def networks filters = { }
          service.networks({ :datacenter => path.join("/") }.merge(filters))
        end

        def datastores filters = { }
          service.datastores({ :datacenter => path.join("/") }.merge(filters))
        end

        def vm_folders filters = { }
          service.folders({ :datacenter => path.join("/"), :type => :vm }.merge(filters))
        end

        def virtual_machines filters = {}
          service.servers({ :datacenter => path.join("/") }.merge(filters))
        end

        def servertypes filters={}
          service.servertypes({:datacenter => name }.merge(filters))
        end

        def customfields filters = {}
          service.customfields({ :datacenter => path.join("/")}.merge(filters))
        end

        def to_s
          name
        end
      end
    end
  end
end
