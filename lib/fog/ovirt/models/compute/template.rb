module Fog
  module Compute
    class Ovirt
      class Template < Fog::Model
        identity :id

        attr_accessor :raw

        attribute :name
        attribute :comment
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
        attribute :volumes
        attribute :version

        def interfaces
          attributes[:interfaces] ||= id.nil? ? [] : Fog::Compute::Ovirt::Interfaces.new(
              :service => service,
              :vm => self
          )
        end

        def volumes
          attributes[:volumes] ||= id.nil? ? [] : Fog::Compute::Ovirt::Volumes.new(
              :service => service,
              :vm => self
          )
        end

        def ready?
          !(status =~ /down/i)
        end

        def destroy(options = {})
          service.client.destroy_template(id)
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          service.client.create_template(attributes)
        end

        def to_s
          name
        end
      end
    end
  end
end
