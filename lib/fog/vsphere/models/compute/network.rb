module Fog
  module Compute
    class Vsphere
      class Network < Fog::Model
        identity :id

        attribute :name
        attribute :datacenter
        attribute :accessible # reachable by at least one hypervisor
        attribute :virtualswitch

        def to_s
          name
        end
      end
    end
  end
end
