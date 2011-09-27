class AWS
  module ACS
    module Formats

      BASIC = {
        'ResponseMetadata' => {'RequestId' => String}
      }

      SECURITY_GROUP = {
        'EC2SecurityGroups' => Array,
        'CacheSecurityGroupName' => String,
        'CacheSecurityGroupDescription' => String,
        'OwnerId' => String
      }

      SINGLE_SECURITY_GROUP = BASIC.merge('CacheSecurityGroup' => SECURITY_GROUP)
      DESCRIBE_SECURITY_GROUPS = BASIC.merge('CacheSecurityGroups' => [SECURITY_GROUP])


    end
  end
end
