module Fog
  module Compute
    class Joyent
      class Key < Fog::Model
        identity :name

        attribute :name
        attribute :key

        attribute :created, :type => :time

        def destroy
          requires :name
          service.delete_key(name)
        end
      end
    end
  end
end
