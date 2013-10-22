require 'fog/core/model'

module Fog
  module Rackspace
    class Queues
      class Claim < Fog::Model

        identity :identity

        attribute :grace
        attribute :ttl
        attribute :limit
        attribute :messages

        def save
          if identity.nil?
            create
          else
            update
          end
        end

        def destroy
          requires :identity, :queue
          service.delete_claim(queue.name, identity)

          #Since Claims aren't a server side collection, we should remove
          # the claim from the collection.
          collection.delete(self)

          true
        end

        def messages=(messages)
          #HACK - Models require a collection, but I don't really want to expose
          # the messages collection to users here.
          message_collection = Fog::Rackspace::Queues::Messages.new({
              :service => service,
              :queue => queue,
              :client_id => service.client_id,
              :echo => true
            })
          attributes[:messages] = messages.collect do |message|
            if message.instance_of? Fog::Rackspace::Queues::Message
              message
            else
              Fog::Rackspace::Queues::Message.new(
                message.merge({
                  :service => service,
                  :collection => message_collection
                }.merge(message))
              )
            end
          end
        end

        private

        def queue
          collection.queue
        end

        def create
          requires :queue, :ttl, :grace, :collection

          options = {}
          options[:limit] = limit unless limit.nil?

          response = service.create_claim(queue.identity, ttl, grace, options)

          if [200, 201].include? response.status
            self.identity = response.headers['Location'].split('/').last
            self.messages = response.body

            #Since Claims aren't a server side collection, we need to
            # add the claim to the collection
            collection << self
            true
          else
            false
          end
        end

        def update
          requires :identity, :queue, :ttl
          service.update_claim(queue.identity, identity, ttl)
          true
        end
      end
    end
  end
end
