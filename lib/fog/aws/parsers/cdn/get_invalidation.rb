module Fog
  module Parsers
    module CDN
      module AWS

        class GetInvalidation < Fog::Parsers::Base

          def reset
            @response = { 'InvalidationBatch' => [] }
          end

          def start_element(name, attrs = [])
            super
          end

          def end_element(name)
            case name
            when 'Path'
              @response['InvalidationBatch'] << @value
            when 'Id', 'Status', 'CreateTime'
              @response[name] = @value
            end
          end

        end

      end
    end
  end
end
