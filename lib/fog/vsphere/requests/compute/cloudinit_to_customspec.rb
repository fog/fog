module Fog
  module Compute
    class Vsphere
      class Real
        def cloudinit_to_customspec(user_data)
          raise ArgumentError, "user_data can't be nil" if user_data.nil?
          custom_spec = { 'customization_spec' => Hash.new }
          user_data = YAML.load(user_data)
          custom_spec['hostname']                    =  user_data['hostname'] if user_data.key?('hostname')
          custom_spec['ipsettings']                  =  { 'ip' => user_data['ip'] } if user_data.key?('ip')
          custom_spec['ipsettings']['subnetMask']    =  user_data['netmask'] if user_data.key?('netmask')
          custom_spec['ipsettings']['dnsServerList'] =  user_data['dns'] if user_data.key?('dns')
          custom_spec['domain']                      =  user_data['domain'] if user_data.key?('domain')
          custom_spec['dnsSuffixList']               =  user_data['domain'] if user_data.key?('domain')
          custom_spec['time_zone']                   =  user_data['timezone'] if user_data.key?('timezone')
          custom_spec           
        end
      end

      class Mock
        def cloudinit_to_customspec(user_data)
          raise ArgumentError, "user_data can't be nil" if user_data.nil?
          custom_spec = { 'customization_spec' => Hash.new }
          user_data = YAML.load(user_data)
          custom_spec['hostname']                    =  user_data['hostname'] if user_data.key?('hostname')
          custom_spec['ipsettings']                  =  { 'ip' => user_data['ip'] } if user_data.key?('ip')
          custom_spec['ipsettings']['subnetMask']    =  user_data['netmask'] if user_data.key?('netmask')
          custom_spec['ipsettings']['dnsServerList'] =  user_data['dns'] if user_data.key?('dns')
          custom_spec['domain']                      =  user_data['domain'] if user_data.key?('domain')
          custom_spec['dnsSuffixList']               =  user_data['domain'] if user_data.key?('domain')
          custom_spec['time_zone']                   =  user_data['timezone'] if user_data.key?('timezone')
          custom_spec
        end
      end
    end
  end
end
