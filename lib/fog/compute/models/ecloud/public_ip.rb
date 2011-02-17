module Fog
  module Ecloud
    class Compute
      class PublicIp < Fog::Ecloud::Model

        identity :href, :aliases => :Href

        ignore_attributes :xmlns, :xmlns_i

        attribute :name, :aliases => :Name
        attribute :id, :aliases => :Id

        def internet_services
          load_unless_loaded!
          @internet_services ||= Fog::Ecloud::Compute::InternetServices.
            new( :connection => connection,
                 :href => href.to_s + "/internetServices" )
        end
      end
    end
  end
end