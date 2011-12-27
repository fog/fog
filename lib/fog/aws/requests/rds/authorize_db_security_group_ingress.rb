module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/authorize_db_security_group_ingress'

        # authorizes a db security group ingress
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/index.html?API_AuthorizeDBSecurityGroupIngress.html
        # ==== Parameters
        # * CIDRIP <~String> - The IP range to authorize
        # * DBSecurityGroupName <~String> - The name for the DB Security Group.
        # * EC2SecurityGroupName <~String> - Name of the EC2 Security Group to authorize.
        # * EC2SecurityGroupOwnerId <~String> - AWS Account Number of the owner of the security group specified in the EC2SecurityGroupName parameter. The AWS Access Key ID is not an acceptable value.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def authorize_db_security_group_ingress(name, opts={})
          unless opts.key?('CIDRIP') || (opts.key?('EC2SecurityGroupName') && opts.key?('EC2SecurityGroupOwnerId'))
            raise ArgumentError, 'Must specify CIDRIP, or both EC2SecurityGroupName and EC2SecurityGroupOwnerId'
          end

          request({
            'Action'  => 'AuthorizeDBSecurityGroupIngress',
            :parser   => Fog::Parsers::AWS::RDS::AuthorizeDBSecurityGroupIngress.new,
            'DBSecurityGroupName' => name
          }.merge(opts))

        end

      end

      class Mock

        def authorize_db_security_group_ingress(name, opts = {})
          unless opts.key?('CIDRIP') || (opts.key?('EC2SecurityGroupName') && opts.key?('EC2SecurityGroupOwnerId'))
            raise ArgumentError, 'Must specify CIDRIP, or both EC2SecurityGroupName and EC2SecurityGroupOwnerId'
          end
          
          response = Excon::Response.new
          
          if sec_group = self.data[:security_groups][name]
            if opts.key?('CIDRIP')
              if sec_group['IPRanges'].detect{|h| h['CIDRIP'] == opts['CIDRIP']}
                raise Fog::AWS::RDS::AuthorizationAlreadyExists.new("AuthorizationAlreadyExists => #{opts['CIDRIP']} is alreay defined")
              end
              sec_group['IPRanges'] << opts.merge({"Status" => 'authorizing'})
            else
              if sec_group['EC2SecurityGroups'].detect{|h| h['EC2SecurityGroupName'] == opts['EC2SecurityGroupName']}
                raise Fog::AWS::RDS::AuthorizationAlreadyExists.new("AuthorizationAlreadyExists => #{opts['EC2SecurityGroupName']} is alreay defined")
              end
              sec_group['EC2SecurityGroups'] << opts.merge({"Status" => 'authorizing'})
            end
            response.status = 200
            response.body = {
              "ResponseMetadata"=>{ "RequestId"=> Fog::AWS::Mock.request_id },
              'AuthorizeDBSecurityGroupIngressResult' => {          
                'DBSecurityGroup' => sec_group
              }
            }
            response
          else
            raise Fog::AWS::RDS::NotFound.new("DBSecurityGroupNotFound => #{name} not found")
          end
          
        end

      end
    end
  end
end

