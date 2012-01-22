module Fog
  module Compute
    class Ovirt

      class Template < Fog::Model

        identity :id

        attribute :name
        attribute :description
        attribute :profile
        attribute :display
        attribute :storage,       :aliases => 'disk_size'
        attribute :creation_time
        attribute :os
        attribute :status
        attribute :cores,         :aliases => 'cpus'
        attribute :memory
        attribute :cluster

        def ready?
          !(status =~ /down/i)
        end

        def destroy(options = {})
          connection.client.destroy_template(id)
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          connection.client.create_template(attributes)
        end

        def to_s
          name
        end

      end

    end
  end
end
