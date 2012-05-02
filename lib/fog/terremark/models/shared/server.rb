require 'fog/core/model'

# { '0' => 'Being created', '1' => 'Being Deployed, '2' => 'Powered Off', '4' => 'Powered On'}
module VAppStatus
  BEING_CREATED = "0"
  BEING_DEPLOYED = "1"
  POWERED_OFF = "2"
  POWERED_ON = "4"
end


module Fog
  module Terremark
    module Shared

      class Server < Fog::Model

        identity :id

        attribute :name
        attribute :image
        attribute :vcpus
        attribute :memory
        attribute :sshkeyFingerPrint
        attribute :status
        attribute :OperatingSystem
        attribute :VirtualHardware
        attribute :IpAddress
        attribute :PublicIpAddress

        def destroy
          case self.status
            when VAppStatus::BEING_CREATED, VAppStatus::BEING_DEPLOYED
              return false
            when VAppStatus::POWERED_ON
              data = connection.power_off(self.id).body
              wait_for { off? }
            end
          connection.delete_vapp(self.id)
          true
        end

        def delete_internet_services

            #Find the internet service
            services = connection.get_internet_services(connection.default_vdc_id)
            internet_services = services.body["InternetServices"].select {|item| item["Name"] == self.name}

            for service in internet_services:
              nodes = connection.get_node_services(service["Id"]).body["NodeServices"]
              #Delete all the associated nodes
              nodes.select { |item| connection.delete_node_service(item["Id"]) }

              #Clear out the services
              connection.delete_internet_service(service["Id"])
            end
            #Release IP Address
            connection.delete_public_ip(service["PublicIpAddress"]["Id"])
            true
        end

        # { '0' => 'Being created', '2' => 'Powered Off', '4' => 'Powered On'}
        def ready?
          state = connection.get_vapp(id).body["status"]  
          state == VAppStatus::POWERED_OFF
        end

        def on?
          state = connection.get_vapp(id).body["status"]
          state == VAppStatus::POWERED_ON
        end

        def off?
          state = connection.get_vapp(id).body["status"]
          state == VAppStatus::POWERED_OFF
        end

        def power_on(options = {})
          requires :id
          begin
            connection.power_on(id)
          rescue Excon::Errors::InternalServerError => e
            #Frankly we shouldn't get here ...
            raise e unless e.to_s =~ /because it is already powered on/
          end
          true
        end

        def power_off
          requires :id
          begin
            connection.power_off(id)
          rescue Excon::Errors::InternalServerError => e
            #Frankly we shouldn't get here ...
            raise e unless e.to_s =~ /because it is already powered off/
          end
          true
        end

        def shutdown
          requires :id
          begin
            connection.power_shutdown(id)
          rescue Excon::Errors::InternalServerError => e
            #Frankly we shouldn't get here ...
            raise e unless e.to_s =~ /because it is already powered off/
          end
          true
        end

        def power_reset
          requires :id
          connection.power_reset(id)
          true
        end

        def graceful_restart
          requires :id
          shutdown
          wait_for { off? }
          power_on
        end

        def create_internet_services(internet_spec)
          public_ip_info = nil
          internet_spec.each do |proto, ports|
            for port in ports
              if not public_ip_info
                #Create the first internet service and allocate public IP
                data = connection.create_internet_service(
                      vdc = connection.default_vdc_id,
                      name = self.name,
                      protocol = proto,
                      port = port,
                      options = {
                        'Enabled' => 'true',
                        "Description" => :name
                      }

                    )
                internet_service_id = data.body["Id"]
                public_ip_info = data.body["PublicIpAddress"]

              else
                #create additional services to existing Public IP
                data = connection.add_internet_service(
                      ip_id = public_ip_info["Id"],                      
                      name = self.name,
                      protocol = proto,
                      port = port,
                      options = {
                        'Enabled' => 'true',
                        "Description" => :name
                      }
                    )
                internet_service_id = data.body["Id"]
              end

              #Create the associate node service to the server
              self.create_node_service(
                internet_service_id,
                proto,
                port
              )
 
            end
         end
          true
        end

        def create_node_service(internet_service_id, protocol="TCP", port="22")
          ssh_service = internet_service_id
          data = connection.add_node_service(
              service_id = ssh_service,
              ip = self.IpAddress,
              name = self.name,
              port = port,
              options = {'Enabled' => 'true',
                         "Description" => :name
                        }
          ) 
          true 
        end

        def save
          requires :name
          data = connection.instantiate_vapp_template(
              server_name=name, 
              vapp_template=image, 
              options={
                  'ssh_key_fingerprint' => sshkeyFingerPrint,
                  'cpus' => vcpus,
                  'memory' => memory
              })
          merge_attributes(data.body)
          true
        end

        private

        def href=(new_href)
          self.id = new_href.split('/').last.to_i
        end

        def type=(new_type); @type = new_type; end
        def size=(new_size); @size = new_size; end
        def Links=(new_links); @Links = new_links; end

      end

    end
  end
end
