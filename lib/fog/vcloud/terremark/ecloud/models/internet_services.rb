module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Real
          def internet_services(options = {})
            @internet_services ||= Fog::Vcloud::Terremark::Ecloud::InternetServices.new(options.merge(:connection => self))
          end
        end

        class InternetServices < Fog::Vcloud::Collection

          model Fog::Vcloud::Terremark::Ecloud::InternetService

          attribute :href, :aliases => :Href

          def all
            if data = connection.get_internet_services(href).body[:InternetService]
              load(data)
            end
          end

          # Optimize later, no need to get_internet_services again
          def get(uri)
            if data = connection.get_internet_services(href).body[:InternetService].detect { |service| service[:Href] == uri }
              new(data)
            end
          rescue Fog::Errors::NotFound
            nil
          end

        end
      end
    end
  end
end
