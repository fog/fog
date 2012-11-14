module Fog
  module Compute
    class Vsphere

      class Folder < Fog::Model

        identity :id

        attribute :name
        attribute :parent
        attribute :datacenter
        attribute :path
        attribute :type

        def vms
          return [] if type.to_s != 'vm'
          connection.servers(:folder => path, :datacenter => datacenter)
        end

        def to_s
          name
        end

      end

    end
  end
end
