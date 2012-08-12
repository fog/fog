
module Fog
  module Parsers
    module Terremark
      module Shared

        class GetKeysList < Fog::Parsers::Base

          def reset
            @response = { 'Keys' => [] }
            @key = {}
          end

          def start_element(name, attributes)
            super
            case name
            when 'Id', 'Href', 'Name', 'IsDefault','FingerPrint'
              data = {}
              until attributes.empty?
                data[attributes.shift] = attributes.shift
              end
              @key[name] = data
            when 'Key'
              until attributes.empty?
                @key[attributes.shift] = attributes.shift
              end
            when 'Keys'
              keys_list = {}
              until attributes.empty?
                if attributes.first.is_a?(Array)
                  attribute = attributes.shift
                  keys_list[attribute.first] = attribute.last
                else
                  keys_list[attributes.shift] = attributes.shift
                end
              end
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
