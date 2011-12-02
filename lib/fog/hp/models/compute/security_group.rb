require 'fog/core/model'

module Fog
  module Compute
    class HP

      class SecurityGroup < Fog::Model

        identity  :id

        attribute :name
        attribute :description
        attribute :rules
        attribute :tenant_id

        def destroy
          requires :id

          connection.delete_security_group(id)
          true
        end

        def save
          requires :name, :description

          data = connection.create_security_group(name, description)
          merge_attributes(data.body['security_group'])
          true
        end

      end
    end
  end
end
