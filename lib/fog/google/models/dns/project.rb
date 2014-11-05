require 'fog/core/model'

module Fog
  module DNS
    class Google
      ##
      # Represents a Project resource
      #
      # @see https://developers.google.com/cloud-dns/api/v1beta1/projects
      class Project < Fog::Model
        identity :id

        attribute :kind
        attribute :number
        attribute :quota

        # These attributes are not available in the representation of a 'Project' returned by the Google DNS API
        attribute :managed_zones
        attribute :rrsets_per_managed_zone
        attribute :resource_records_per_rrset
        attribute :rrset_additions_per_change
        attribute :rrset_deletions_per_change
        attribute :total_rrdatasize_per_change

        ##
        # Returns the maximum allowed number of managed zones in the project
        #
        # @return [Integer] Maximum allowed number of managed zones in the project
        def managed_zones
          self.quota['managedZones']
        end

        ##
        # Returns the maximum allowed number of ResourceRecordSets per zone in the project
        #
        # @return [Integer] The maximum allowed number of ResourceRecordSets per zone in the project
        def rrsets_per_managed_zone
          self.quota['rrsetsPerManagedZone']
        end

        ##
        # Returns the maximum allowed number of resource records per ResourceRecordSet
        #
        # @return [Integer] The maximum allowed number of resource records per ResourceRecordSet
        def resource_records_per_rrset
          self.quota['resourceRecordsPerRrset']
        end

        ##
        # Returns the maximum allowed number of ResourceRecordSets to add per Changes.create request
        #
        # @return [Integer] The maximum allowed number of ResourceRecordSets to add per Changes.create request
        def rrset_additions_per_change
          self.quota['rrsetAdditionsPerChange']
        end

        ##
        # Returns the maximum allowed number of ResourceRecordSets to delete per Changes.create request
        #
        # @return [Integer] The maximum allowed number of ResourceRecordSets to delete per Changes.create request
        def rrset_deletions_per_change
          self.quota['rrsetDeletionsPerChange']
        end

        ##
        # Returns the maximum allowed size in bytes for the rrdata field in one Changes.create request
        #
        # @return [Integer] The maximum allowed size in bytes for the rrdata field in one Changes.create request
        def total_rrdatasize_per_change
          self.quota['totalRrdataSizePerChange']
        end
      end
    end
  end
end
