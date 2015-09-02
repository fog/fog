module Fog
  module Rackspace
    class NetworkingV2
      class SecurityGroup < Fog::Model

        identity :id

        attribute :name
        attribute :description
        attribute :tenant_id

        def save
          data = unless self.id.nil?
            service.update_security_group(self)
          else
            service.create_security_group(self)
          end

          merge_attributes(data.body['security_group'])
          true
        end

        def destroy
          requires :identity

          service.delete_security_group(identity)
          true
        end
      end
    end
  end
end
