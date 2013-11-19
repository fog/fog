require 'fog/core/model'

module Fog
  module Rackspace
    class Queues
      class Message < Fog::Model

        attribute :age
        attribute :ttl
        attribute :body
        attribute :href
        attribute :claim_id

        def identity
          return nil unless href

          match = href.match(/(\/(\w+))*\??/)
          match ? match[-1] : nil
        end
        alias :id :identity

        def save
          requires :queue, :client_id, :body, :ttl
          raise "Message has already been created and may not be updated." unless identity.nil?
          data = service.create_message(client_id, queue.name, body, ttl).body
          self.href = data['resources'][0]
          true
        end

        def destroy
          requires :identity, :queue
          options = {}
          options[:claim_id] = claim_id unless claim_id.nil?

          service.delete_message(queue.name, identity, options)
          true
        end

        private

        def queue
          collection.queue
        end

        def client_id
          collection.client_id
        end
      end
    end
  end
end
