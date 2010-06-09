require 'fog/model'

module Fog
  module Vcloud
    module Terremark
      module Ecloud
        class Network < Fog::Vcloud::Model

          identity :href

          attribute :name
          attribute :features
          attribute :configuration
          attribute :ips_link
          attribute :type
          attribute :xmlns

          def ips
            unless @loaded
              reload
            end
            @ips ||= Fog::Vcloud::Terremark::Ecloud::Ips.
              new( :connection => connection,
                   :href => ips_link.href )
          end
        end
      end
    end
  end
end


