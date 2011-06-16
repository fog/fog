module Fog
  module Compute
    class AWS
      class Real
        
        require 'fog/compute/parsers/aws/basic'

        # Modify snapshot attributes
        #
        # ==== Parameters
        # * snapshot_id<~String> - Id of snapshot to modify
        # * attribute<~String> - Attribute to modify, in ['createVolumePermission']
        # * operation_type<~String> - Operation to perform on attribute, in ['add', 'remove']
        #
        #
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-ModifySnapshotAttribute.html]
        #
        def modify_snapshot_attribute(snapshot_id, attribute, operation_type, options = {})
          params = {}
          params.merge!(Fog::AWS.indexed_param('UserId', options['UserId']))
          params.merge!(Fog::AWS.indexed_param('UserGroup', options['UserGroup']))
          request({
            'Action'        => 'ModifySnapshotAttribute',
            'Attribute'     => attribute,
            'SnapshotId'    => snapshot_id,
            'OperationType' => operation_type,
            :idempotent     => true,
            :parser         => Fog::Parsers::Compute::AWS::Basic.new
          }.merge!(params))
        end

      end
    end
  end
end
