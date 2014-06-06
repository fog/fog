module Fog
  module Parsers
    module Compute
      module AWS
        class CreateSnapshot < Fog::Parsers::Base
          def end_element(name)
            case name
            when 'description', 'ownerId', 'progress', 'snapshotId', 'status', 'volumeId'
              @response[name] = value
            when 'requestId'
              @response[name] = value
            when 'startTime'
              @response[name] = Time.parse(value)
            when 'volumeSize'
              @response[name] = value.to_i
            end
          end
        end
      end
    end
  end
end
