module Fog
  module Compute
    class Ecloud
      class PublicIp < Fog::Ecloud::Model

        identity :href, :aliases => :Href

        ignore_attributes :xmlns, :xmlns_i

        attribute :name, :aliases => :Name
        attribute :id, :aliases => :Id

        def internet_services
          load_unless_loaded!
          @internet_services ||= Fog::Compute::Ecloud::InternetServices.
            new( :connection => connection,
                 :href => href.to_s + "/internetServices" )
        end
      end
    end
  end
end