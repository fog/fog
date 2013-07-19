module Fog
  module Parsers
    module Storage
      module AWS

        class CompleteMultipartUpload < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'Bucket', 'ETag', 'Key', 'Location', 'Code', 'Message'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
