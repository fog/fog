module Fog
  module Compute
    class Cloudstack
      class PortForwardingRule < Fog::Model
        identity  :id,                      :aliases => 'id'

        attribute :private_port,              :aliases => 'privateport'
        attribute :private_end_port,          :aliases => 'privateendport'
        attribute :protocol,                  :aliases => 'protocol'
        attribute :public_port,               :aliases => 'publicport'
        attribute :public_end_port,           :aliases => 'publicendport'
        attribute :virtual_machine_id,        :aliases => 'virtualmachineid'
        attribute :virtualmachinename,        :aliases => 'virtualmachinename'
        attribute :virtualmachinedisplayname, :aliases => 'virtualmachinedisplayname'
        attribute :ipaddressid,               :aliases => 'ipaddressid'
        attribute :ipaddress,                 :aliases => 'ipaddress'
        attribute :state,                     :aliases => 'state'
        attribute :cidrlist,                  :aliases => 'cidrlist'
        attribute :vmguestip,                 :aliases => 'vmguestip'
        attribute :networkid,                 :aliases => 'networkid'
        attribute :tags,                      :type => :array
      end
    end
  end
end
