module Fog
  module Parsers
    module CDN
      module AWS

        class PostInvalidation < Fog::Parsers::Base

          def reset
            @response = { 'InvalidationBatch' => { 'Path' => [] } }
          end

          def end_element(name)
            case name
            when 'CallerReference'
              @response['InvalidationBatch'][name] = value
            when 'CreateTime', 'Id', 'Status'
              @response[name] = value
            when 'Path'
              @response['InvalidationBatch'][name] << value
            end
          end

        end

      end
    end
  end
end
