module Fog
  module Parsers
    module AWS
      module S3

        class CopyObject < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'ETag'
              @response[name] = @value
            when 'LastModified'
              @response[name] = Time.parse(@value)
            end
          end

        end

      end
    end
  end
end
