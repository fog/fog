module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists security groups
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listSecurityGroups.html]
        def list_security_groups(options={})
          options.merge!(
            'command' => 'listSecurityGroups',
             
          )
          request(options)
        end
      end
 
      class Mock
        def list_security_groups(options={})
          security_groups = []
          if security_group_id = options['id']
            security_group = self.data[:security_groups][security_group_id]
            raise Fog::Compute::Cloudstack::BadRequest unless security_group
            security_groups = [security_group]
          else
            security_groups = self.data[:security_groups].values
          end

          {
            "listsecuritygroupsresponse" =>
            {
              "count"         => security_groups.size,
              "securitygroup" => security_groups
            }
          }
        end
      end 
    end
  end
end

