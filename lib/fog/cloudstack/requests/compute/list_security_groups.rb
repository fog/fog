module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists security groups
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listSecurityGroups.html]
        def list_security_groups(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listSecurityGroups') 
          else
            options.merge!('command' => 'listSecurityGroups')
          end
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

