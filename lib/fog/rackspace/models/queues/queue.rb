require 'fog/core/model'

module Fog
  module Rackspace
    class Queues
      class Queue < Fog::Model

        identity :name

        def messages
          @messages ||= begin
            Fog::Rackspace::Queues::Messages.new({
              :service => service,
              :queue => self,
              :client_id => service.client_id,
              :echo => true
            })
          end
        end

        def stats
          service.get_queue_stats(name).body['messages']
        end

        def claims
          @claims ||= begin
            Fog::Rackspace::Queues::Claims.new({
              :service => service,
              :queue => self
            })
          end
        end

        #Helper method to enqueue a single message
        def enqueue(body, ttl, options = {})
          messages.create(options.merge(options.merge({:body => body, :ttl => ttl})))
        end

        #Helper method to claim (dequeue) a single message, including destroying it
        def dequeue(ttl, grace, options = {}, &block)
          claim = claims.create(
            options.merge(
            {
              :limit => 1,
              :ttl => ttl,
              :grace => grace
            }))

          if claim
            message = claim.messages.first
            yield message
            message.destroy
            true
          else
            false
          end
        end

        def save
          requires :name
          data = service.create_queue(name)
          true
        end

        def destroy
          requires :name
          service.delete_queue(name)
          true
        end
      end
    end
  end
end
