module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'

        # Modify image attributes
        #
        # ==== Parameters
        # * image_id<~String> - Id of machine image to modify
        # * attributes<~Hash>:
        #   * 'Add.Group'<~Array> - One or more groups to grant launch permission to
        #   * 'Add.UserId'<~Array> - One or more account ids to grant launch permission to
        #   * 'Description.Value'<String> - New description for image
        #   * 'ProductCode'<~Array> - One or more product codes to add to image (these can not be removed)
        #   * 'Remove.Group'<~Array> - One or more groups to revoke launch permission from
        #   * 'Remove.UserId'<~Array> - One or more account ids to revoke launch permission from
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-ModifyImageAttribute.html]
        #
        def modify_image_attribute(image_id, attributes)
          raise ArgumentError.new("image_id is required") unless image_id

          params = {}
          params.merge!(Fog::AWS.indexed_param('LaunchPermission.Add.%d.Group', attributes['Add.Group'] || []))
          params.merge!(Fog::AWS.indexed_param('LaunchPermission.Add.%d.UserId', attributes['Add.UserId'] || []))
          params.merge!(Fog::AWS.indexed_param('LaunchPermission.Remove.%d.Group', attributes['Remove.Group'] || []))
          params.merge!(Fog::AWS.indexed_param('LaunchPermission.Remove.%d.UserId', attributes['Remove.UserId'] || []))
          params.merge!(Fog::AWS.indexed_param('ProductCode', attributes['ProductCode'] || []))
          request({
            'Action'        => 'ModifyImageAttribute',
            'ImageId'       => image_id,
            :idempotent     => true,
            :parser         => Fog::Parsers::Compute::AWS::Basic.new
          }.merge!(params))
        end

      end
    end
  end
end
