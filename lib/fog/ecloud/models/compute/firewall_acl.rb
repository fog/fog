module Fog
  module Compute
    class Ecloud
      class FirewallAcl < Fog::Ecloud::Model
        identity :href

        attribute :type, :aliases => :Type
        attribute :links, :aliases => :Links
        attribute :permission, :aliases => :Permission
        attribute :acl_type, :aliases => :AclType
        attribute :port_type, :aliases => :PortType
        attribute :protocol, :aliases => :Protocol
        attribute :source, :aliases => :Source
        attribute :destination, :aliases => :Destination
        attribute :port_range, :aliases => :PortRange

        def tasks
          @tasks = Fog::Compute::Ecloud::Tasks.new(:service => service, :href => "#{service.base_path}/tasks/virtualMachines/#{id}")
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
