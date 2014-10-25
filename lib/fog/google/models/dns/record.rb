require 'fog/core/model'

module Fog
  module DNS
    class Google
      ##
      # Resource Record Sets resource
      #
      # @see https://cloud.google.com/dns/api/v1beta1/resourceRecordSets
      class Record < Fog::Model
        identity :name

        attribute :kind
        attribute :type
        attribute :ttl
        attribute :rrdatas

        ##
        # Deletes a previously created Resource Record Sets resource
        #
        # @param [Boolean] async If the operation must be asyncronous (true by default)
        # @return [Boolean] If the Resource Record Set has been deleted
        def destroy(async = true)
          requires :name, :type, :ttl, :rrdatas

          data = service.create_change(self.zone.id, [], [resource_record_set_format])
          change = Fog::DNS::Google::Changes.new(:service => service, :zone => zone).get(data.body['id'])
          unless async
            change.wait_for { ready? }
          end
          true
        end

        ##
        # Modifies a previously created Resource Record Sets resource
        #
        # @param [Hash] new_attributes Resource Record Set new attributes
        # @return [Fog::DNS::Google::Record] Resource Record Sets resource
        def modify(new_attributes)
          requires :name, :type, :ttl, :rrdatas

          deletions = resource_record_set_format
          merge_attributes(new_attributes)

          data = service.create_change(self.zone.id, [resource_record_set_format], [deletions])
          change = Fog::DNS::Google::Changes.new(:service => service, :zone => zone).get(data.body['id'])
          async = new_attributes.has_key?(:async) ? new_attributes[:async] : true
          unless async
            change.wait_for { ready? }
          end
          self
        end

        ##
        # Reloads a Resource Record Sets resource
        #
        # @return [Fog::DNS::Google::Record] Resource Record Sets resource
        def reload
          requires :name, :type

          data = collection.get(self.name, self.type)
          merge_attributes(data.attributes)
          self
        end

        ##
        # Creates a new Resource Record Sets resource
        #
        # @return [Fog::DNS::Google::Record] Resource Record Sets resource
        def save
          requires :name, :type, :ttl, :rrdatas

          data = service.create_change(self.zone.id, [resource_record_set_format], [])
          change = Fog::DNS::Google::Changes.new(:service => service, :zone => zone).get(data.body['id'])
          change.wait_for { !pending? }
          self
        end

        ##
        # Returns the Managed Zone of the Resource Record Sets resource
        #
        # @return [Fog::DNS::Google::Zone] Managed Zone of the Resource Record Sets resource
        def zone
          @zone
        end

        private

        ##
        # Assigns the Managed Zone of the Resource Record Sets resource
        #
        # @param [Fog::DNS::Google::Zone] new_zone Managed Zone of the Resource Record Sets resource
        def zone=(new_zone)
          @zone = new_zone
        end

        ##
        # Resource Record Sets resource representation
        #
        def resource_record_set_format
          {
            'kind' => 'dns#resourceRecordSet',
            'name' => self.name,
            'type' => self.type,
            'ttl'  => self.ttl,
            'rrdatas' => self.rrdatas,
          }
        end
      end
    end
  end
end
