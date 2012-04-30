require 'fog/core/model'

module Fog
  module Terremark
    module Shared

      class Server < Fog::Model

        identity :id

        attribute :name
        attribute :image
        attribute :sshkeyFingerPrint
        attribute :status
        attribute :OperatingSystem
        attribute :VirtualHardware
        attribute :IpAddress
        attribute :PublicIpAddress

        def destroy
          case self.status
            when "0"
              return false
            when "4"
              data = connection.power_off(self.id).body
              wait_for { off? }
            end
          connection.delete_vapp(self.id)
          true
        end

        def delete_internet_services

            #Find the internet service
            services = connection.get_internet_services(connection.default_vdc_id)
            internet_info = services.body["InternetServices"].find {|item| item["Name"] == self.name}

            #Delete all the associated nodes
            if internet_info
              nodes = connection.get_node_services(internet_info["Id"]).body["NodeServices"]
              nodes.select { |item| connection.delete_node_service(item["Id"]) }

              #Clear out the services
              connection.delete_internet_service(internet_info["Id"])

              #Release IP Address
              connection.delete_public_ip(internet_info["PublicIpAddress"]["Id"])
            end
            true
        end

        # { '0' => 'Being created', '2' => 'Powered Off', '4' => 'Powered On'}
        def ready?
          state = connection.get_vapp(id).body["status"]  
          puts " id : #{id}, state : #{state}"
          state == '2'
        end

        def on?
          state = connection.get_vapp(id).body["status"]
          puts " id : #{id}, state : #{state}"
          state == '4'
        end

        def off?
          state = connection.get_vapp(id).body["status"]
          state == '2'
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

        def create_internet_service(protocol="TCP", port="22")
          data = connection.create_internet_service(
              vdc = connection.default_vdc_id,
              name = self.name,
              protocol = protocol,
              port = port,
              options = {'Enabled' => 'true',
                         "Description" => :name
                        }
          )
          merge_attributes(data.body)
          ssh_service = data.body["Id"]
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
          data = connection.instantiate_vapp_template(server_name=name, vapp_template=image, options={'ssh_key_fingerprint'=>sshkeyFingerPrint})
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
