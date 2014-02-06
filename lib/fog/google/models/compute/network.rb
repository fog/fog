require 'fog/core/model'

module Fog
  module Compute
    class Google 
      class Network < Fog::Model

        identity :name
        attribute :id
        attribute :self_link, aliases: 'selfLink'
        attribute :description
        attribute :creation_timestamp, aliases: 'creationTimestamp'
        attribute :ip_v4_range, aliases: 'IPv4Range'
        attribute :gateway_ip_v4, aliases: 'gatewayIPv4'


        def reload 
          requires :name
          response  = service.get_network(name)
          attributes = response.body
          self.merge_attributes(attributes)
          self
        end

        def delete 
          requires :name
          response = service.delete_network(name)
          service.operations.new(response.body)
        end

        def save
          requires :name, :ip_v4_range
          response = service.insert_network(name, ip_v4_range)
          service.operations.new(response.body)
        end

        def url
          "https://www.googleapis.com/compute/v1/projects/#{service.project}/global/networks/#{name}"
        end
      end
    end
  end
end

