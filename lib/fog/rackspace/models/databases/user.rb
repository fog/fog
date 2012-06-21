require 'fog/core/model'

module Fog
  module Rackspace
    class Databases
      class User < Fog::Model
        identity :name

        attribute :password
        attribute :databases

        def save
          requires :identity, :instance, :password
          connection.create_user(instance.identity, identity, password, :databases => databases)
          true
        end

        def destroy
          requires :identity, :instance
          connection.delete_user(instance.identity, identity)
          true
        end

        private

        def instance
          collection.instance
        end
      end
    end
  end
end
