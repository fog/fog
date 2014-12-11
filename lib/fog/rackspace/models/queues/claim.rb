require 'fog/core/model'

module Fog
  module Rackspace
    class Queues
      class Claim < Fog::Model
        # @!attribute [r] identity
        # @return [String] The claim's id
        identity :identity

        # @!attribute [rw] grace
        # @return [Integer] The grace attribute specifies the message grace period in seconds. The value of grace value must be between 60 and 43200 seconds (12 hours).
        #   You must include a value for this attribute in your request. To deal with workers that have stopped responding (for up to 1209600 seconds or 14 days, including
        #   claim lifetime), the server extends the lifetime of claimed messages to be at least as long as the lifetime of the claim itself, plus the specified grace period.
        #   If a claimed message would normally live longer than the grace period, its expiration is not adjusted.
        attribute :grace

        # @!attribute [rw] ttl
        # @return [Integer] The ttl attribute specifies how long the server waits before releasing the claim. The ttl value must be between 60 and 43200 seconds (12 hours).
        attribute :ttl

        # @!attribute [rw] limit
        # @return [Integer] Specifies the number of messages to return, up to 20 messages. If limit is not specified, limit defaults to 10.
        attribute :limit

        # @!attribute [r] limit
        # @return [Array<Fog::Rackspace::Queues::Messages>, Array<Strings>] Specifies the number of messages to return, up to 20 messages.
        #   If limit is not specified, limit defaults to 10.
        attribute :messages

        alias_method :id, :identity

        # Creates or updates a claim
        #
        # @return [Boolean] returns true if claim is being created
        #
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/POST_claimMessages__version__queues__queue_name__claims_claims-operations-dle001.html
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/PATCH_updateClaim__version__queues__queue_name__claims__claimId__claims-operations-dle001.html
        def save
          if identity.nil?
            create
          else
            update
          end
        end

        # Destroys Claim
        #
        # @return [Boolean] returns true if claim is deleted
        #
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/DELETE_deleteClaim__version__queues__queue_name__claims__claimId__claims-operations-dle001.html
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
          attributes[:messages] = messages.map do |message|
            if message.instance_of? Fog::Rackspace::Queues::Message
              message.claim_id = self.id
              message
            else
              Fog::Rackspace::Queues::Message.new(
                message.merge({
                  :service => service,
                  :collection => message_collection,
                  :claim_id => self.id
                }.merge(message))
              )
            end
          end
        end

        def initialize(new_attributes = {})
          # A hack in support of the #messages= hack up above. #messages= requires #collection to
          # be populated first to succeed, which is always the case in modern Rubies that preserve
          # Hash ordering, but not in 1.8.7.
          @collection = new_attributes.delete(:collection)
          super(new_attributes)
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
            self.identity = response.get_header('Location').split('/').last
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
