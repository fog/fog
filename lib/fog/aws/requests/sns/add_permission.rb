module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/add_permission'

        def add_permission(options = {})
          request({
            'Action'  => 'AddPermission',
            :parser   => Fog::Parsers::AWS::SNS::AddPermission.new
          }.merge!(options))
        end

      end

      class Mock

        def add_permission(options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
