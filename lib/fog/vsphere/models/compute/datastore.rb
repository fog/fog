module Fog
  module Compute
    class Vsphere
      class Datastore < Fog::Model
        identity :id

        attribute :name
        attribute :datacenter
        attribute :type
        attribute :freespace
        attribute :accessible # reachable by at least one hypervisor
        attribute :capacity
        attribute :uncommitted

        def to_s
          name
        end
      end
    end
  end
end
