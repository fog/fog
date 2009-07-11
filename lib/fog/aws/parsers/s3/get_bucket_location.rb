require File.dirname(__FILE__) + '/../../../parser'

module Fog
  module Parsers
    module AWS
      module S3

        class GetBucketLocation < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'LocationConstraint'
              @response[:location_constraint] = @value
            end
          end

        end

      end
    end
  end
end
