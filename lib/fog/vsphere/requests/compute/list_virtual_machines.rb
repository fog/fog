module Fog
  module Compute
    class Vsphere
      class Real

        def list_virtual_machines
          virtual_machines = Array.new

          datacenters = @connection.rootFolder.children.find_all do |child|
            child.kind_of? RbVmomi::VIM::Datacenter
          end
          # Next, look in the "vmFolder" of each data center:
          datacenters.each do |dc|
            dc.vmFolder.children.each do |vm|
              virtual_machines << vm
            end
          end
          virtual_machines
        end

      end

      class Mock

        def list_virtual_machines
          Fog::Mock.not_implmented
        end

      end
    end
  end
end

