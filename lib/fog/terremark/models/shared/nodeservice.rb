require 'fog/core/model'

module Fog
  module Terremark
    module Shared

      class NodeService < Fog::Model

        identity :Id
        attribute :Name
        attribute :Href
        attribute :Port
        attribute :Description
        attribute :IpAddress
        attribute :Enabled
        attribute :InternetServiceId

        def destroy
          connection.delete_node_service(self.Id)
        end

        def save
         requires :Name, :Port, :InternetServiceId
            data = connection.add_node_service(
                service_id = self.InternetServiceId,
                ip = self.IpAddress,
                name = self.Name,
                port = self.Port,
                options = {"Enabled" => 'true',
                           "Description" => self.Name,
                }
            
            )
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
