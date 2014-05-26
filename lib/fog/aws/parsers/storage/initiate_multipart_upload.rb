module Fog
  module Parsers
    module Storage
      module AWS
        class InitiateMultipartUpload < Fog::Parsers::Base
          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'Bucket', 'Key', 'UploadId'
              @response[name] = value
            end
          end
        end
      end
    end
  end
end
