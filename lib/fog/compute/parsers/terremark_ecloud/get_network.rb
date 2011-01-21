module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetNetwork < Fog::Parsers::Base

          def reset
            @response = {
              'Configuration' => {},
              'Features' => {},
              'Link' => {}
            }
          end

          def start_element(name, attrs = [])
            case name
            when 'Network'
              for attribute in %w{href name}
                if value = attr_value(attribute, attrs)
                  @response[attribute] = value
                end
              end
            when 'Link'
              for attribute in %w{href name rel type}
                if value = attr_value(attribute, attrs)
                  @response[name][attribute] = value
                end
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
                @response['Configuration'][name] = @value
              end
            when 'Features'
              @in_features = false
            else
              if @in_features
                @response['Features'][name] = @value
              end
            end
          end
        end
      end
    end
  end
end
