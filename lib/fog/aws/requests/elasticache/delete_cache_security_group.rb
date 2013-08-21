module Fog
  module AWS
    class Elasticache
      class Real

        require 'fog/aws/parsers/elasticache/base'

        # deletes a cache security group
        #
        # === Parameters
        # * name <~String> - The name for the Cache Security Group
        # === Returns
        # * response <~Excon::Response>:
        #   * body <~Hash>
        def delete_cache_security_group(name)
          request({
            'Action' => 'DeleteCacheSecurityGroup',
            'CacheSecurityGroupName' => name,
            :parser => Fog::Parsers::AWS::Elasticache::Base.new
          })
        end
      end

      class Mock
        def delete_cache_security_group(name)
          response = Excon::Response.new

          if self.data[:security_groups].delete(name)
            response.status = 200
            response.body = {
              "ResponseMetadata"=>{ "RequestId"=> Fog::AWS::Mock.request_id },
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
