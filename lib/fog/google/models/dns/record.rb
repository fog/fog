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
        # @return [Boolean] If the Resource Record Set has been deleted
        def destroy
          requires :name, :type, :ttl, :rrdatas

          service.create_change(self.zone.id, [], [resource_record_set_format])
          true
        end

        ##
        # Modifies a previously created Resource Record Sets resource
        #
        # @return [Fog::DNS::Google::Record] Resource Record Sets resource
        def modify(new_attributes)
          requires :name, :type, :ttl, :rrdatas

          deletions = resource_record_set_format
          merge_attributes(new_attributes)

          service.create_change(self.zone.id, [resource_record_set_format], [deletions])
          self
        end

        ##
        # Creates a new Resource Record Sets resource
        #
        # @return [Fog::DNS::Google::Record] Resource Record Sets resource
        def save
          requires :name, :type, :ttl, :rrdatas

          service.create_change(self.zone.id, [resource_record_set_format], [])
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
