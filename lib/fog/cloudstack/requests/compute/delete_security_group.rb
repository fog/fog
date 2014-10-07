module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes security group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteSecurityGroup.html]
        def delete_security_group(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteSecurityGroup') 
          else
            options.merge!('command' => 'deleteSecurityGroup')
          end
          request(options)
        end
      end
 
      class Mock
        def delete_security_group(options={})
          security_group_id = options['id']
          if self.data[:security_groups][security_group_id]
            self.data[:security_groups].delete(security_group_id)
            {
              "deletesecuritygroupresponse" => {
                "success" => "true"
              }
            }
          else
            raise Fog::Compute::Cloudstack::BadRequest.new('No security_group found')
          end
        end
      end 
    end
  end
end

