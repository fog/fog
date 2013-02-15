
module Fog
  module Parsers
    module Terremark
      module Shared

        class GetKeysList < TerremarkParser
          def reset
            @response = { 'Keys' => [] }
            @key = {}
          end

          def start_element(name, attributes)
            super
            case name
            when 'Id', 'Href', 'Name', 'IsDefault','FingerPrint'
              data = extract_attributes(attributes)
              @key[name] = data
            when 'Key'
              @key = extract_attributes(attributes)
            when 'Keys'
              keys_list = extract_attributes(attributes)
              @response['href'] = keys_list['href']
            end
          end

          def end_element(name)
            case name
            when 'Id', 'Href', 'Name', 'IsDefault','FingerPrint'
            @key[name] = value
            when 'Key'
              @response['Keys'] << @key
              @key = {}
            end
          end

        end

      end
    end
  end
end
