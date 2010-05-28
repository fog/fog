module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Mock
          def internet_services(options = {})
            @internet_services ||= Fog::Vcloud::Terremark::Ecloud::InternetServices.new(options.merge(:connection => self))
          end
        end

        module Real
          def internet_services(options = {})
            @internet_services ||= Fog::Vcloud::Terremark::Ecloud::InternetServices.new(options.merge(:connection => self))
          end
        end

        class InternetServices < Fog::Vcloud::Collection

          attr_accessor :href

          model Fog::Vcloud::Terremark::Ecloud::InternetService

          vcloud_type "application/vnd.tmrk.ecloud.internetService+xml"
          all_request lambda { |internet_services| internet_services.raw_results }

          def get(uri)
            if internet_service = get_raw(uri)
              item = new(:href => internet_service.href)
              item.reload
            end
          end

          def get_raw(uri)
            raw_results.body.links.detect { |link| link.href == uri }
          end

          def raw_results
            @raw_results ||= connection.get_internet_services(self.href)
          end

          #def reload
          #  super
          #  @raw_results = nil
          #end

        end
      end
    end
  end
end
