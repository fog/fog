module Fog
  module Compute
    class Vsphere

      class Datacenter < Fog::Model

        identity :id
        attribute :name
        attribute :status

        def clusters filters = { }
          connection.clusters({ :datacenter => name }.merge(filters))
        end

        def networks filters = { }
          connection.networks({ :datacenter => name }.merge(filters))
        end

        def datastores filters = { }
          connection.datastores({ :datacenter => name }.merge(filters))
        end

        def vm_folders filters = { }
          connection.folders({ :datacenter => name, :type => :vm }.merge(filters))
        end

        def to_s
          name
        end

      end

    end
  end
end
