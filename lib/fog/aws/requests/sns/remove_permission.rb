module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/remove_permission'

        def remove_permission(options = {})
          request({
            'Action'  => 'RemovePermission',
            :parser   => Fog::Parsers::AWS::SNS::RemovePermission.new
          }.merge!(options))
        end

      end

      class Mock

        def remove_permission(options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
