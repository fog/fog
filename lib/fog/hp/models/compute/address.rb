require 'fog/core/model'

module Fog
  module Compute
    class HP

      class Address < Fog::Model

        identity  :id

        attribute :ip
        attribute :fixed_ip
        attribute :instance_id

        def destroy
          requires :id

          connection.release_address(id)
          true
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          data = connection.allocate_address.body['floating_ip']
          new_attributes = data.reject {|key,value| !['id', 'instance_id', 'ip', 'fixed_ip'].include?(key)}
          merge_attributes(new_attributes)
          true
        end

      end

    end
  end
end
