module Fog
  module Compute
    class Ovirt

      class Template < Fog::Model

        identity :id

        attr_accessor :raw

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
        attribute :interfaces


        def interfaces
          attributes[:interfaces] ||= id.nil? ? [] : Fog::Compute::Ovirt::Interfaces.new(
              :connection => connection,
              :vm => self
          )
        end

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
