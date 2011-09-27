module Fog
  module Parsers
    module AWS
      module Elasticache
        require 'fog/aws/parsers/elasticache/engine_defaults_parser'

        class DescribeCacheParameters < EngineDefaultsParser

          def end_element(name)
            case name
            when 'DescribeCacheParametersResult'
              @response[name] = @engine_defaults
              reset_engine_defaults
            else
              super
            end
          end
        end
      end
    end
  end
end
