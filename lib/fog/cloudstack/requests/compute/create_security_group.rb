module Fog
  module Compute
    class Cloudstack
      class Real
        def create_security_group(options={})
          options.merge!(
            'command' => 'createSecurityGroup'
          )

          request(options)
        end
      end # Real

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
