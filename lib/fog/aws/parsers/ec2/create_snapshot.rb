module Fog
  module Parsers
    module AWS
      module EC2

        class CreateSnapshot < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'progress', 'snapshotId', 'status', 'volumeId'
              @response[name] = @value
            when 'startTime'
              @response[name] = Time.parse(@value)
            end
          end

        end

      end
    end
  end
end