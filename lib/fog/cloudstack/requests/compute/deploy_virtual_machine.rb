module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates and automatically starts a virtual machine based on a service offering, disk offering, and template.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/deployVirtualMachine.html]
        def deploy_virtual_machine(options={})
          options.merge!(
            'command' => 'deployVirtualMachine'
          )

          security_group_ids = options.delete(:security_group_ids)
          if security_group_ids
            options.merge!('securitygroupids' => Array(security_group_ids).join(','))
          end

          security_group_names = options.delete(:security_group_names)
          if security_group_names
            options.merge!('securitygroupnames' => Array(security_group_names).join(','))
          end

          network_ids = options.delete(:network_ids)
          if network_ids
            options.merge!('networkids' => Array(network_ids).join(','))
          end

          options["zoneid"]=            options.delete(:zone_id)             if options.key?(:zone_id)
          options["templateid"]=        options.delete(:template_id)         if options.key?(:template_id)
          options["serviceofferingid"]= options.delete(:service_offering_id) if options.key?(:service_offering_id)

          request(options)
        end
      end # Real

      class Mock

        def deploy_virtual_machine(options={})
          zone_id = options[:zone_id]
          unless zone_id
            raise Fog::Compute::Cloudstack::BadRequest.new('Unable to execute API command deployvirtualmachine due to missing parameter zoneid')
          end
          unless zone = self.data[:zones][zone_id]
            raise Fog::Compute::Cloudstack::BadRequest.new("Unable to execute API command deployvirtualmachine due to invalid value. Object networks(uuid: #{zone_id}) does not exist.")
          end
          zone_name = zone[:name]

          template_id = options[:template_id]
          unless template = self.data[:templates][options[:template_id]]
            raise Fog::Compute::Cloudstack::BadRequest.new('Unable to execute API command deployvirtualmachine due to missing parameter templateid')
          end
          template_name = template[:name]
          template_display_text = template[:display_text]

          service_offering_id = options[:service_offering_id]
          unless service_offering = self.data[:service_offerings][options[:service_offering_id]]
            raise Fog::Compute::Cloudstack::BadRequest.new('Unable to execute API command deployvirtualmachine due to missing parameter serviceofferingid')
          end

          service_offering_name = service_offering[:name]
          service_offering_cpu_number = service_offering[:cpunumber]
          service_offering_cpu_speed = service_offering[:cpuspeed]
          service_offering_memory = service_offering[:cpumemory]

          identity = Fog::Cloudstack.uuid
          name = options[:name] || Fog::Cloudstack.uuid
          display_name = options[:display_name] || name
          account_name = options[:account] || self.data[:accounts].first[1]["name"]

          domain = options[:domain_id] ? self.data[:domains][options[:domain_id]] : self.data[:domains].first[1]
          domain_id = domain[:id]
          domain_name = domain[:name]

          # how is this setup
          password = nil
          password_enabled = false

          guest_os_id = Fog::Cloudstack.uuid

          security_group_ids = options[:security_group_ids] || [] # TODO: for now

          network_ids = Array(options[:network_ids]) || [self.data[:networks].first[1]["id"]]
          networks = network_ids.map{|nid| self.data[:networks][nid]}
          nic = networks.map do |network|
            {
              "id" => Fog::Cloudstack.uuid,
              "networkid" => network["id"],
              "netmask" => Fog::Cloudstack.ip_address,
              "gateway" => network["gateway"],
              "ipaddress" => Fog::Cloudstack.ip_address,
              "traffictype" => "Guest", # TODO: ?
              "type" => network["type"],
              "isdefault" => true, # TODO: ?
              "macaddress" => Fog::Cloudstack.mac_address
            }
          end

          virtual_machine = {
            "id" => identity,
            "name" => name,
            "displayname" => display_name,
            "account" => account_name,
            "domainid" => domain_id,
            "domain" => domain_name,
            "created" => Time.now.to_s,
            "state" => "Running",
            "haenable" => false,
            "zoneid" => zone_id,
            "zonename" => zone_name,
            "templateid" => template_id,
            "templatename" => template_name,
            "templatedisplaytext" => template_display_text,
            "passwordenabled" => false,
            "serviceofferingid" => service_offering_id,
            "serviceofferingname" => service_offering_name,
            "cpunumber" => service_offering_cpu_number,
            "cpuspeed" => service_offering_cpu_speed,
            "memory" => service_offering_memory,
            "cpuused" => "0%",
            "networkkbsread" => 0,
            "networkkbswrite" => 0,
            "guestosid" => guest_os_id,
            "rootdeviceid" => 0,
            "rootdevicetype" => "NetworkFilesystem",
            "securitygroup" => security_group_ids, # TODO: mayhaps?
            "nic" => nic
          }
          self.data[:servers][identity]= virtual_machine
          {'deployvirtualmachineresponse' => virtual_machine}
        end
      end # Mock
    end # Cloudstack
  end # Compute
end # Fog
