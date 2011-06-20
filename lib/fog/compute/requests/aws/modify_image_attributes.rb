module Fog
  module Compute
    class AWS
      class Real

        require 'fog/compute/parsers/aws/basic'

        # Modify image attributes
        #
        # ==== Parameters
        # * image_id<~String> - Id of machine image to modify
        # * attribute<~String> - Attribute to modify, in ['launchPermission', 'productCodes']
        # * operation_type<~String> - Operation to perform on attribute, in ['add', 'remove']
        #
        #
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-ModifyImageAttribute.html]
        #
        def modify_image_attributes(image_id, attribute, operation_type, options = {})
          params = {}
          params.merge!(Fog::AWS.indexed_param('UserId', options['UserId']))
          params.merge!(Fog::AWS.indexed_param('UserGroup', options['UserGroup']))
          params.merge!(Fog::AWS.indexed_param('ProductCode', options['ProductCode']))
          request({
            'Action'        => 'ModifyImageAttribute',
            'Attribute'     => attribute,
            'ImageId'       => image_id,
            'OperationType' => operation_type,
            :idempotent     => true,
            :parser         => Fog::Parsers::Compute::AWS::Basic.new
          }.merge!(params))
        end

      end
    end
  end
end
