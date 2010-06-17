module Fog
  module Vcloud
    module Terremark
      module Ecloud

        class Servers < Fog::Vcloud::Collection

          model Fog::Vcloud::Terremark::Ecloud::Server

          attribute :href, :aliases => :Href

          def all
            load(_vapps)
          end

          def get(uri)
            if data = connection.get_vapp(uri)
              new(data.body)
            end
          rescue Fog::Errors::NotFound
            nil
          end

          private

          def _resource_entities
            connection.get_vdc(href).body[:ResourceEntities][:ResourceEntity]
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
end
