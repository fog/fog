require 'fog/core/model'

module Fog
  module Identity
    class OpenStack
      class Role < Fog::Model
        identity :id
        attribute :name
        attribute :description

        def save
          requires :name
          data = connection.create_role(name)
          merge_attributes(data.body['role'])
          true
        end

        def destroy
          connection.delete_role(id)
          true
        end
      end # class Role
    end # class OpenStack
  end # module Identity
end # module Fog
