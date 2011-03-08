module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/revoke_db_security_group_ingress'

        # revokes a db security group ingress
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/index.html?API_RevokeDBSecurityGroupIngress.html
        # ==== Parameters
        # * CIDRIP <~String> - The IP range to revoke
        # * DBSecurityGroupName <~String> - The name for the DB Security Group.
        # * EC2SecurityGroupName <~String> - Name of the EC2 Security Group to revoke.
        # * EC2SecurityGroupOwnerId <~String> - AWS Account Number of the owner of the security group specified in the EC2SecurityGroupName parameter. The AWS Access Key ID is not an acceptable value.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def revoke_db_security_group_ingress(name, opts={})
          unless opts.key?('CIDRIP') || (opts.key?('EC2SecurityGroupName') && opts.key?('EC2SecurityGroupOwnerId'))
            raise ArgumentError, 'Must specify CIDRIP, or both EC2SecurityGroupName and EC2SecurityGroupOwnerId'
          end

          request({
            'Action'  => 'RevokeDBSecurityGroupIngress',
            :parser   => Fog::Parsers::AWS::RDS::RevokeDBSecurityGroupIngress.new,
            'DBSecurityGroupName' => name
          }.merge(opts))

        end

      end

      class Mock

        def revoke_db_security_group_ingress(name, opts = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end


