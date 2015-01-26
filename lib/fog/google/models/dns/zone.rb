require 'fog/core/model'

module Fog
  module DNS
    class Google
      ##
      # Managed Zone resource
      #
      # @see https://developers.google.com/cloud-dns/api/v1beta1/managedZones
      class Zone < Fog::Model
        identity :id

        attribute :creation_time, :aliases => 'creationTime'
        attribute :description
        attribute :domain, :aliases => 'dnsName'
        attribute :kind
        attribute :name
        attribute :nameservers, :aliases => 'nameServers'

        ##
        # Enumerates the list of Changes for the Managed Zone
        #
        # @return Array<Fog::DNS::Google::Change>] List of Changes for the Managed Zone
        def changes
          @changes = begin
            Fog::DNS::Google::Changes.new(
              :service => service,
              :zone => self
            )
          end
        end

        ##
        # Deletes a previously created Managed Zone
        #
        # @return [Boolean] If the Managed Zone has been deleted
        def destroy
          requires :identity

          service.delete_managed_zone(self.identity)
          true
        end

        ##
        # Enumerates the list of Resource Record Sets for the Managed Zone
        #
        # @return Array<Fog::DNS::Google::Record>] List of Resource Record Sets for the Managed Zone
        def records
          @records = begin
            Fog::DNS::Google::Records.new(
              :service => service,
              :zone => self
            )
          end
        end

        ##
        # Creates a new Managed Zone
        #
        # @return [Fog::DNS::Google::Zone] Managed Zone
        # @raise [Fog::Errors::Error] If Managed Zone already exists
        def save
          requires :name, :domain, :description

          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?

          data = service.create_managed_zone(self.name, self.domain, self.description)
          merge_attributes(data.body)
          self
        end
      end
    end
  end
end
