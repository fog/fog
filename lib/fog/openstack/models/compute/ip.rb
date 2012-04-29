require 'fog/core/model'

module Fog
  module Compute
    class OpenStack

      class Ip < Fog::Model

        identity :id

        attribute :ip
        attribute :pool
        attribute :fixed_ip
        attribute :instance_id

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          data = connection.allocate_ip(self)
          merge_attributes(data.body['floating_ip'])
          true
        end

        def destroy
          requires :id
          connection.deallocate_ip(self)
          true
        end

      end

    end
  end
end
