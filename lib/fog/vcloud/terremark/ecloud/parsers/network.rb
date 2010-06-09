module Fog
  module Parsers
    module Vcloud
      module Terremark
        module Ecloud

          class Network < Fog::Parsers::Vcloud::Network

            def reset
              @response = Struct::TmrkEcloudNetwork.new([])
            end

            def start_element(name,attributes=[])
              super
              case name
              when "Link"
                @response.ips_link = generate_link(attributes)
              end
            end

          end
        end
      end
    end
  end
end


