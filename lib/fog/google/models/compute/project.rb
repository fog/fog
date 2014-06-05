require 'fog/core/model'

module Fog
  module Compute
    class Google
      ##
      # Represents a Project resource
      #
      # @see https://developers.google.com/compute/docs/reference/latest/projects
      class Project < Fog::Model
        identity :name

        attribute :kind
        attribute :id
        attribute :common_instance_metadata, :aliases => 'commonInstanceMetadata'
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :description
        attribute :quotas
        attribute :self_link, :aliases => 'selfLink'

        def set_metadata(metadata = {})
          requires :identity

          data = service.set_common_instance_metadata(identity, self.common_instance_metadata['fingerprint'], metadata)
          Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'])
        end
      end
    end
  end
end
