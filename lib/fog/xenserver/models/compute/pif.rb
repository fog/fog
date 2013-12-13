require 'fog/core/model'

module Fog
  module Compute
    class XenServer

      class PIF < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=PIF

        identity :reference

        attribute :uuid
        attribute :__bond_master_of,            :aliases => :bond_master_of
        attribute :__bond_slave_of,             :aliases => :bond_slave_of
        attribute :disallow_unplug
        attribute :physical
        attribute :mac,                         :aliases => :MAC
        attribute :currently_attached
        attribute :device
        attribute :device_name
        attribute :metrics
        attribute :dns,                         :aliases => :DNS
        attribute :gateway
        attribute :ip,                          :aliases => :IP
        attribute :ip_configuration_mode
        attribute :ipv6,                        :aliases => :IPv6
        attribute :ipv6_configuration_mode
        attribute :ipv6_gateway
        attribute :mtu,                         :aliases => :MTU
        attribute :__network,                   :aliases => :network
        attribute :netmask
        attribute :status_code
        attribute :status_detail
        attribute :management
        attribute :primary_address_type
        attribute :__tunnel_access_pif_of,      :aliases => :tunnel_access_PIF_of
        attribute :__tunnel_transport_pif_of,   :aliases => :tunnel_transport_PIF_of
        attribute :vlan,                        :aliases => :VLAN
        attribute :vlan_master_of,              :aliases => :VLAN_master_of
        attribute :vlan_slave_of,               :aliases => :VLAN_slave_of
        attribute :other_config
        attribute :__host,                      :aliases => :host

        def network
          service.networks.get __network
        end

        def host
          service.hosts.get __host
        end

      end

    end
  end
end
