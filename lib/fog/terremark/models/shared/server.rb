require 'fog/core/model'
require 'fog/terremark/models/shared/nodeservices'
require 'fog/terremark/models/shared/internetservices'

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
        attribute :powerOn
        attribute :status
        attribute :OperatingSystem
        attribute :VirtualHardware
        attribute :IpAddress

        def reload
         merge_attributes(connection.get_vapp(id).body)
        end
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

        def PublicIpAddress
          @PublicIpAddress ||=
            if internet_services.size > 0
              internet_services[0].PublicIpAddress["Name"]
            end
          @PublicIpAddress
        end

        def internet_services
            @internet_services ||= connection.internetservices.all.select {|item| item.Name == self.name}
        end
        
        def delete_internet_services
            #Find the internet service

            while (service = internet_services.pop) do

              nodes = connection.nodeservices.all(service.Id)
              #Delete all the associated nodes
              nodes.select { |item| item.destroy }
              #Clear out the services
              service.destroy(delete_public_ip = !(internet_services.size > 0))
            end
            true
        end

        # { '0' => 'Being created', '2' => 'Powered Off', '4' => 'Powered On'}
        def ready?
          status == VAppStatus::POWERED_OFF
        end

        def on?
          status == VAppStatus::POWERED_ON
        end

        def off?
          status == VAppStatus::POWERED_OFF
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
          internet_service_id = nil
          internet_spec.each do |proto, ports|
            for port in ports
              if not public_ip_info
                #Create the first internet service and allocate public IP
                inet_services = connection.internetservices.create({
                      "Name" => self.name,
                      "Protocol" => proto,
                      "Port" => port,
                })
                internet_service_id = inet_services.Id
                public_ip_info = inet_services.PublicIpAddress

              else
                #create additional services to existing Public IP
                inet_services = connection.internetservices.create({
                      "public_ip_address_id" => public_ip_info["Id"],                      
                      "Name" => self.name,
                      "Protocol" => proto,
                      "Port" => port,
                }
                    )
                internet_service_id = inet_services.Id
              end

              #Create the associate node service to the server
              connection.nodeservices.create({"Name" => self.name, 
                                           "IpAddress" => self.IpAddress,
                                           "Port" => port,
                                           "InternetServiceId" => internet_service_id
              })
            end
          end
          true
        end

        def save
          requires :name
          if powerOn
          end
          data = connection.instantiate_vapp_template(
              server_name=name, 
              vapp_template=image, 
              options={
                  'ssh_key_fingerprint' => sshkeyFingerPrint,
                  'cpus' => vcpus,
                  'memory' => memory
              })

          merge_attributes(data.body)
          wait_for { ready? }

          #Optional, incase further configuration required.
          if powerOn
            power_on
            wait_for { ready? }
          end

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
