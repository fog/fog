module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetNetwork < Fog::Parsers::Base

          def reset
            @response = { 'configuration' => {}, 'features' => {} }
          end

          def start_element(name, attrs = [])
            case name
            when 'Network'
              @response['name'] = attr_value('name', attrs)
              @response['uri']  = attr_value('href', attrs)
            when 'Link'
              href = attr_value('href', attrs)

              case attr_value('name', attrs) # wut
              when @response['name']
                @response['extensions_uri'] = href
              when 'IP Addresses'
                @response['extensions_ips_uri'] = href
              end
            when 'Configuration'
              @in_configuration = true
            when 'Features'
              @in_features = true
            end

            super
          end

          def end_element(name)
            case name
            when 'Configuration'
              @in_configuration = false
            when 'Gateway', 'Netmask'
              if @in_configuration
                @response['configuration'][name.downcase] = @value
              end
            when 'Features'
              @in_features = false
            else
              if @in_features
                @response['features'][name] = @value
              end
            end
          end
        end
      end
    end
  end
end
