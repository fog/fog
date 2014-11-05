require 'fog/core/model'

module Fog
  module DNS
    class Google
      ##
      # Represents a Change resource
      #
      # @see https://developers.google.com/cloud-dns/api/v1beta1/changes
      class Change < Fog::Model
        identity :id

        attribute :kind
        attribute :start_time, :aliases => 'startTime'
        attribute :status
        attribute :additions
        attribute :deletions

        DONE_STATE    = 'done'
        PENDING_STATE = 'pending'

        ##
        # Checks if the change operation is pending
        #
        # @return [Boolean] True if the change operation is pending; False otherwise
        def pending?
          self.status == PENDING_STATE
        end

        ##
        # Checks if the change operation is done
        #
        # @return [Boolean] True if the change operation is done; False otherwise
        def ready?
          self.status == DONE_STATE
        end
      end
    end
  end
end
