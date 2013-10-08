require 'fog/core/collection'
require 'fog/rackspace/models/queues/message'

module Fog
  module Rackspace
    class Queues
      class Messages < Fog::Collection

        model Fog::Rackspace::Queues::Message

        attr_accessor :client_id
        attr_accessor :queue
        attr_accessor :echo
        attr_accessor :limit
        attr_accessor :marker
        attr_accessor :include_claimed

        def all
          requires :client_id, :queue
          response = service.list_messages(client_id, queue.name, options)
          if response.status == 204
            data = []
          else
            data = response.body['messages']
          end
          load(data)
        end

        def get(message_id)
          requires :client_id, :queue
          data = service.get_message(client_id, queue.name, message_id).body
          new(data)
        rescue Fog::Rackspace::Queues::NotFound
          nil
        # HACK - This has been escalated to the Rackspace Queues team, as this 
        # behavior is not normal HTTP behavior.
        rescue Fog::Rackspace::Queues::ServiceError
          nil
        end

        private

        def options
          data = {}
          data[:echo] = echo.to_s unless echo.nil?
          data[:limit] = limit.to_s unless limit.nil?
          data[:marker] = marker.to_s unless marker.nil?
          data[:include_claimed] = include_claimed.to_s unless include_claimed.nil?
          data
        end
      end
    end
  end
end
