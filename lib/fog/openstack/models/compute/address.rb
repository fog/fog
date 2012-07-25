require 'fog/core/model'

module Fog
  module Compute
    class OpenStack

      class Address < Fog::Model

        identity  :id

        attribute :ip
        attribute :pool
        attribute :fixed_ip
        attribute :instance_id

        def initialize(attributes = {})
          # assign server first to prevent race condition with new_record?
          self.server = attributes.delete(:server)
          super
        end

        def destroy
          requires :id
          connection.release_address(id)
          true
        end

        def server=(new_server)
          if new_server
            associate(new_server)
          else
            disassociate
          end
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          data = connection.allocate_address(pool).body['floating_ip']
          new_attributes = data.reject {|key,value| !['id', 'instance_id', 'ip', 'fixed_ip'].include?(key)}
          merge_attributes(new_attributes)
          if @server
            self.server = @server
          end
          true
        end

        private

        def associate(new_server)
          if new_record?
            @server = new_server
          else
            @server = nil
            self.instance_id = new_server.id
            connection.associate_address(instance_id, ip)
          end
        end

        def disassociate
          @server = nil
          unless new_record?
            connection.disassociate_address(instance_id, ip)
          end
          self.instance_id = nil
        end

      end

    end
  end
end
