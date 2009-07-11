require File.dirname(__FILE__) + '/../../../parser'

module Fog
  module Parsers
    module AWS
      module S3

        class CopyObject < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'ETag'
              @response[:etag] = @value
            when 'LastModified'
              @response[:last_modified] = Time.parse(@value)
            end
          end

        end

      end
    end
  end
end
