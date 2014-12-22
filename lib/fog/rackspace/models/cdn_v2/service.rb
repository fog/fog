require 'fog/core/model'

module Fog
  module Rackspace
    class CDNV2 < Fog::Service
      class Service < Fog::Model

        attr_accessor :operations

        UUID_REGEX = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/

        identity :id

        attribute :name
        attribute :domains
        attribute :origins
        attribute :caching
        attribute :restrictions
        attribute :flavor_id
        attribute :status
        attribute :links

        def initialize(options={})
          self.operations = []
          super
        end

        def add_domain(domain, options={})
          self.domains ||= []
          self.domains << {domain: domain}.merge(options)
          self.domains
        end

        def add_origin(origin, options={})
          self.origins ||= []
          self.origins << {origin: origin}.merge(options)
          self.origins
        end

        def add_operation(options={})
          self.operations << options
        end

        def save
          if id.nil?
            data = service.create_service(self)
            loc  = data.headers["Location"]
            id   = UUID_REGEX.match(loc)[0]
            merge_attributes(id: id)
          else
            service.update_service(self)
          end
        end

        def destroy
          service.delete_service(self)
        end

        def destroy_assets(options={})
          service.delete_assets(self, options)
        end

      end
    end
  end
end
