require 'fog/ecloud/models/compute/server'

module Fog
  module Compute
    class Ecloud

      class Servers < Fog::Ecloud::Collection

        undef_method :create

        model Fog::Compute::Ecloud::Server

        attribute :href, :aliases => :Href

        def all
          check_href!(:parent => "Vdc")
          load(_vapps)
        end

        def get(uri)
          if data = connection.get_vapp(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def create( catalog_item_uri, options )
          options[:vdc_uri] = href
          options[:cpus] ||= 1
          options[:memory] ||= 512
          data = connection.instantiate_vapp_template( catalog_item_uri, options ).body
          object = new(data)
          object
        end

        private

        def _resource_entities
          if Hash === resource_entities = connection.get_vdc(href).body[:ResourceEntities]
            resource_entities[:ResourceEntity]
          end
        end

        def _vapps
          resource_entities = _resource_entities
          if resource_entities.nil?
            []
          else
            resource_entities
          end
        end

      end
    end
  end
end
