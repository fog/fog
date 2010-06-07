require 'fog/model'

module Fog
  module Vcloud
    module Terremark
      module Ecloud
        class PublicIp < Fog::Vcloud::Model

          identity :href

          attribute :name
          attribute :type
          attribute :id

          def internet_services
            unless @loaded
              reload
            end
            @internet_services ||= Fog::Vcloud::Terremark::Ecloud::InternetServices.
              new( :connection => connection,
                   :href => href.to_s + "/internetServices" )
          end
        end
      end
    end
  end
end

