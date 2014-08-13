require 'fog/rackspace/core'

module Fog
  module Rackspace
    class Queues < Fog::Service
      include Fog::Rackspace::Errors

      class ServiceError < Fog::Rackspace::Errors::ServiceError; end
      class InternalServerError < Fog::Rackspace::Errors::InternalServerError; end
      class BadRequest < Fog::Rackspace::Errors::BadRequest; end
      class MethodNotAllowed < Fog::Rackspace::Errors::BadRequest; end

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url
      recognizes :rackspace_auth_token
      recognizes :rackspace_region
      recognizes :rackspace_queues_url
      recognizes :rackspace_queues_client_id

      model_path 'fog/rackspace/models/queues'
      model :queue
      collection :queues
      model :message
      collection :messages
      model :claim
      collection :claims

      request_path 'fog/rackspace/requests/queues'
      request :list_queues
      request :get_queue
      request :create_queue
      request :delete_queue
      request :get_queue_stats

      request :list_messages
      request :get_message
      request :create_message
      request :delete_message
      request :create_claim
      request :get_claim
      request :update_claim
      request :delete_claim

      module Common
        def apply_options(options)
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_queues_client_id = options[:rackspace_queues_client_id] || Fog::UUID.uuid
          @rackspace_auth_url = options[:rackspace_auth_url]
          @rackspace_queues_url = options[:rackspace_queues_url]
          @rackspace_must_reauthenticate = false
          @connection_options = options[:connection_options] || {}
          @rackspace_region = options[:rackspace_region]

          unless v2_authentication?
            raise Fog::Errors::NotImplemented.new("V2 authentication required for Queues")
          end

          unless @rackspace_region || @rackspace_queues_url
            Fog::Logger.deprecation("Default region support will be removed in an upcoming release. Please switch to manually setting your endpoint. This requires settng the :rackspace_region option.")
          end

          @rackspace_region ||= :ord
        end

        def service_name
          :cloudQueues
        end

        def region
          @rackspace_region
        end

        def endpoint_uri(service_endpoint_url=nil)
          @uri = super(@rackspace_queues_url || service_endpoint_url, :rackspace_queues_url)
        end

        def authenticate(options={})
          super({
            :rackspace_api_key  => @rackspace_api_key,
            :rackspace_username => @rackspace_username,
            :rackspace_auth_url => @rackspace_auth_url,
            :connection_options => @connection_options
          })
        end

        def client_id
          @rackspace_queues_client_id
        end

        def client_id=(client_id)
          @rackspace_queues_client_id = client_id
        end
      end

      class Mock < Fog::Rackspace::Service
        include Common

        PATH_BASE = "/v1/queues"

        # An in-memory Queue implementation.
        class MockQueue
          attr_accessor :name, :metadata, :messages, :claims

          def initialize(name)
            @name, @metadata = name, {}
            @messages, @claims = [], {}
            @id_counter = Fog::Mock.random_hex(24).to_i(16)
          end

          # The total number of messages currently on the queue.
          #
          # @return [Integer]
          def total
            @messages.size
          end

          # The number of messages currently held by a claim.
          #
          # @return [Integer]
          def claimed
            @messages.count { |msg| msg.claimed? }
          end

          # The number of messages not held by any claim.
          #
          # @return [Integer]
          def free
            @messages.count { |msg| ! msg.claimed? }
          end

          # The oldest published message on this queue, or `nil`.
          #
          # @return [MockMessage|UndefinedObject]
          def oldest
            @messages.first
          end

          # The most recently published message on this queue, or `nil`.
          #
          # @return [MockMessage|UndefinedObject]
          def newest
            @messages.last
          end

          # Append a new message to the queue.
          #
          # @param client_id [String] UUID for the service object.
          # @param data [Hash] Message payload.
          # @param ttl [Integer] Number of seconds that the message should exist.
          # @return [MockMessage] The message object that was created.
          def add_message(client_id, data, ttl)
            id = @id_counter.to_s(16)
            @id_counter += 1
            message = MockMessage.new(id, self, client_id, data, ttl)
            @messages << message
            message
          end

          # Create a new MockClaim.
          #
          # @param ttl [Integer] Time-to-live for the claim.
          # @param grace [Integer] Grace period that's added to messages included in this claim.
          def add_claim(ttl, grace)
            claim = MockClaim.new(self, ttl, grace)
            claims[claim.id] = claim
            claim
          end

          # Access an existing MockClaim by id.
          #
          # @param claim_id [String] An ID of an existing claim.
          # @raises [Fog::Rackspace::Queues::NotFound] If no MockClaim with this ID exists.
          # @return [MockClaim] The requested MockClaim.
          def claim!(claim_id)
            claims[claim_id] or raise NotFound.new
          end

          # Remove any messages or claims whose ttls have expired.
          def ageoff
            messages.reject! { |m| m.expired? }

            claims.keys.dup.each do |id|
              claim = claims[id]
              if claim.expired? || claim.messages.empty?
                claim.messages.each { |m| m.claim = nil }
                claims.delete(id)
              end
            end
          end
        end

        # A single message posted to an in-memory MockQueue.
        class MockMessage
          attr_accessor :id, :queue, :data, :ttl, :producer_id
          attr_accessor :claim, :created

          # Create a new message. Use {MockQueue#add_message} instead.
          def initialize(id, queue, client_id, data, ttl)
            @id, @queue, @producer_id = id, queue, client_id
            @data, @ttl = data, ttl
            @created = Time.now.to_i
            @claim = nil
          end

          # Determine how long ago this message was created, in seconds.
          #
          # @return [Integer]
          def age
            Time.now.to_i - @created
          end

          # Generate a URI segment that identifies this message.
          #
          # @return [String]
          def href
            "#{PATH_BASE}/#{@queue.name}/messages/#{@id}"
          end

          # Return true if this message has been claimed.
          #
          # @return [Boolean]
          def claimed?
            ! @claim.nil?
          end

          # Determine if this message has lived longer than its designated ttl.
          #
          # @return [Boolean]
          def expired?
            age > ttl
          end

          # Extend the {#ttl} of this message to include the lifetime of the claim it belongs to,
          # plus the claim's grace period.
          def extend_life
            return unless @claim
            extended = claim.message_end_of_life - @created
            @ttl = extended if extended > @ttl
          end

          # Convert this message to a GET payload.
          #
          # @return [Hash]
          def to_h
            {
              "body" => @data,
              "age" => age,
              "ttl" => @ttl,
              "href" => href
            }
          end
        end

        # Reservation indicating that a consumer is in the process of handling a collection of
        # messages from a queue.
        class MockClaim
          attr_accessor :id, :queue, :ttl, :grace

          # Create a new MockClaim. Clients should use {MockQueue#add_claim} instead.
          #
          # @param queue [MockQueue] The queue that owns this claim.
          # @param ttl [Integer] Duration, in seconds, that this queue should last.
          # @param grace [Integer] Extra life granted to messages within this claim after this
          #   claim expires, to give another consumer a chance to process it.
          def initialize(queue, ttl, grace)
            @queue = queue
            @id = Fog::Mock.random_hex(24)
            @ttl, @grace = ttl, grace
            touch!
          end

          # Set or reset the creation time of the claim to the present.
          def touch!
            @created = Time.now.to_i
          end

          # Calculate the time at which messages belonging to this claim should expire.
          #
          # @return [Integer] Seconds since the epoch.
          def message_end_of_life
            @created + @ttl + @grace
          end

          # Determine how long ago this claim was created, in seconds.
          #
          # @return [Integer]
          def age
            Time.now.to_i - @created
          end

          # Determine if this claim has lasted longer than its designated ttl.
          #
          # @return [Boolean]
          def expired?
            age > ttl
          end

          # Access the collection of messages owned by this claim.
          #
          # @return [Array<Message>]
          def messages
            @queue.messages.select { |m| m.claim == self }
          end

          # Convert this claim into a GET payload.
          #
          # @return [Hash]
          def to_h
            ms = messages.map { |m| m.to_h }

            {
              "age" => age,
              "href" => "#{PATH_BASE}/#{@queue.name}/claims/#{@id}",
              "ttl" => @ttl,
              "messages" => ms
            }
          end
        end

        def initialize(options = {})
          apply_options(options)
          authenticate
          endpoint_uri
        end

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def data
          self.class.data[@rackspace_username]
        end

        # Create and remember a MockQueue with a given name. An existing MockQueue with the same
        # name will be overridden without warning.
        #
        # @param [String] Valid queue name.
        # @return [MockQueue] The MockQueue that was created.
        def add_queue(queue_name)
          queue = MockQueue.new(queue_name)
          data[queue_name] = queue
          queue
        end

        # Access a MockQueue with the specified name, or return `nil`.
        #
        # @param queue_name [String] Valid queue name.
        # @return [MockQueue|UndefinedObject] The queue with the specified name, or `nil` if
        #   it doesn't exist.
        def mock_queue(queue_name)
          data[queue_name]
        end

        # Access a MockQueue with the specified name, raising an exception if it doesn't exist.
        #
        # @param queue_name [String] Valid queue name.
        # @raises [Fog::Rackspace::Queue::NotFound] If there is no queue with the specified name.
        # @return [MockQueue] The queue with the specified name.
        def mock_queue!(queue_name)
          mock_queue(queue_name) or raise NotFound.new
        end

        # Remove any messages or expire any claims that have exceeded their ttl values. Invoked
        # before every request.
        def ageoff
          data.values.each { |q| q.ageoff }
        end

        def request(params)
          ageoff
          super
        end
      end

      class Real < Fog::Rackspace::Service
        include Common

        def initialize(options = {})
          apply_options(options)

          authenticate

          @persistent = options[:persistent] || false
          @connection = Fog::Core::Connection.new(endpoint_uri.to_s, @persistent, @connection_options)
        end

        def request(params, parse_json = true, &block)
          super(params, parse_json, &block)
        rescue Excon::Errors::NotFound => error
          raise NotFound.slurp(error, self)
        rescue Excon::Errors::BadRequest => error
          raise BadRequest.slurp(error, self)
        rescue Excon::Errors::InternalServerError => error
          raise InternalServerError.slurp(error, self)
        rescue Excon::Errors::MethodNotAllowed => error
          raise MethodNotAllowed.slurp(error, self)
        rescue Excon::Errors::HTTPStatusError => error
          raise ServiceError.slurp(error, self)
        end
      end
    end
  end
end
