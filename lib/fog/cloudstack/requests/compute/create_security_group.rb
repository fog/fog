module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a security group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createSecurityGroup.html]
        def create_security_group(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createSecurityGroup') 
          else
            options.merge!('command' => 'createSecurityGroup', 
            'name' => args[0])
          end
          request(options)
        end
      end
 
      class Mock
        def create_security_group(options={})
          security_group_id = Fog::Cloudstack.uuid

          security_group = {
            "id" => security_group_id,
          }.merge(options)

          self.data[:security_groups][security_group_id]= security_group
          {"createsecuritygroupresponse" => { "securitygroup" => security_group}}
        end
      end 
    end
  end
end

