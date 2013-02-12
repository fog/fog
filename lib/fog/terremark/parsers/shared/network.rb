module Fog
  module Parsers
    module Terremark
      module Shared

        class Network < TerremarkParser

          def reset
            @response = {
              "links" => []
            }
          end

          def start_element(name,attributes=[])
            super
            case name
            when "Network"
              @response = extract_attributes(attributes)
              if @response.has_key?("name")
                @response["subnet"] = @response["name"]
              end
              if @response.has_key?("href")
                @response["id"] = @response["href"].split("/").last
              end
            when "Link"
              link = extract_attributes(attributes)
              @response["links"] << link
            end
          end

          def end_element(name)
            case name
            when "Gateway", "Netmask", "FenceMode"
              @response[name.downcase] = value
            end
          end

        end

      end
    end
  end
end
