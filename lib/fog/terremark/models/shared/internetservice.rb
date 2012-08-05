require 'fog/core/model'

module Fog
  module Terremark
    module Shared

      class InternetService < Fog::Model

        identity :Id

        attribute :Name
        attribute :Port
        attribute :Protocol
        attribute :Description
        attribute :PublicIpAddress
        attribute :public_ip_address_id

        def destroy(delete_public_ip=true)
          connection.delete_internet_service(self.Id)
          connection.delete_public_ip(self.PublicIpAddress["Id"]) if delete_public_ip
        true
        end

        def save
          requires :Name, :Protocol, :Port
          if not public_ip_address_id
            #Create the first internet service and allocate public IP
            data = connection.create_internet_service(
                vdc = connection.default_vdc_id,
                name = self.Name,
                protocol = self.Protocol,
                port = self.Port,
                options = {
                        'Enabled' => 'true',
                        "Description" => self.Name
                }
            )
          else
            #create additional services to existing Public IP
            data = connection.add_internet_service(
                      ip_id = public_ip_address_id,
                      name = self.Name,
                      protocol = self.Protocol,
                      port = self.Port,
                      options = {
                        'Enabled' => 'true',
                        "Description" => self.Name
                        }
                    )           
            end
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
