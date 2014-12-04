module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates and automatically starts a virtual machine based on a service offering, disk offering, and template.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deployVirtualMachine.html]
        def deploy_virtual_machine(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deployVirtualMachine')
          else
            options.merge!('command' => 'deployVirtualMachine',
            'templateid' => args[0],
            'zoneid' => args[1],
            'serviceofferingid' => args[2])
          end
          # add project id if we have one
          @cloudstack_project_id ? options.merge!('projectid' => @cloudstack_project_id) : nil
          request(options)
        end
      end

      class Mock
        def deploy_virtual_machine(options={})
          zone_id = options['zoneid']
          unless zone_id
            raise Fog::Compute::Cloudstack::BadRequest.new('Unable to execute API command deployvirtualmachine due to missing parameter zoneid')
          end
          unless zone = self.data[:zones][zone_id]
            raise Fog::Compute::Cloudstack::BadRequest.new("Unable to execute API command deployvirtualmachine due to invalid value. Object zone(uuid: #{zone_id}) does not exist.")
          end
          zone_name = zone[:name]

          template_id = options['templateid']
          unless template = self.data[:images][template_id]
            raise Fog::Compute::Cloudstack::BadRequest.new('Unable to execute API command deployvirtualmachine due to missing parameter templateid')
          end
          template_name = template[:name]
          template_display_text = template[:display_text]

          service_offering_id = options['serviceofferingid']
          unless service_offering = self.data[:flavors][service_offering_id]
            raise Fog::Compute::Cloudstack::BadRequest.new('Unable to execute API command deployvirtualmachine due to missing parameter serviceofferingid')
          end

          service_offering_name = service_offering[:name]
          service_offering_cpu_number = service_offering[:cpunumber]
          service_offering_cpu_speed = service_offering[:cpuspeed]
          service_offering_memory = service_offering[:cpumemory]

          identity = Fog::Cloudstack.uuid
          name = options['name'] || Fog::Cloudstack.uuid
          display_name = options['displayname'] || name
          account_name = options['account'] || self.data[:accounts].first[1]["name"]

          domain = options['domainid'] ? self.data[:domains][options['domainid']] : self.data[:domains].first[1]
          domain_id = domain[:id]
          domain_name = domain[:name]

          # how is this setup
          password = nil
          password_enabled = false

          guest_os_id = Fog::Cloudstack.uuid

          security_group_ids = options['securitygroupids'] || [] # TODO: for now

          network_ids = Array(options['networkids']) || [self.data[:networks].first[1]["id"]]
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
      end
    end
  end
end

