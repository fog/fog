module Fog
  module Compute
    class Vsphere

      class Template < Fog::Model

        # TODO: find out if some methods are needed for creating and deleteing templates
        #

        identity :id
        attribute :name
        attribute :uuid

        attribute :name
        attribute :uuid
        attribute :hostname
        attribute :operatingsystem
        attribute :public_ip_address, :aliases => 'ipaddress'
        attribute :power_state,   :aliases => 'power'
        attribute :tools_state,   :aliases => 'tools'
        attribute :tools_version
        attribute :mac_addresses, :aliases => 'macs'
        attribute :hypervisor,    :aliases => 'host'
        attribute :connection_state
        attribute :mo_ref
        attribute :path
        attribute :relative_path
        attribute :memory_mb
        attribute :cpus
        attribute :interfaces
        attribute :volumes
        attribute :overall_status, :aliases => 'status'
        attribute :cluster
        attribute :datacenter
        attribute :resource_pool
        attribute :instance_uuid # move this --> id
        attribute :guest_id

      end

    end
  end
end
