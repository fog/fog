module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes security group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteSecurityGroup.html]
        def delete_security_group(options={})
          options.merge!(
            'command' => 'deleteSecurityGroup'  
          )
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

