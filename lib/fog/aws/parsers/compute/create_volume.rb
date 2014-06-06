module Fog
  module Parsers
    module Compute
      module AWS
        class CreateVolume < Fog::Parsers::Base
          def end_element(name)
            case name
            when 'availabilityZone', 'requestId', 'snapshotId', 'status', 'volumeId', 'volumeType'
              @response[name] = value
            when 'createTime'
              @response[name] = Time.parse(value)
            when 'size', 'iops'
              @response[name] = value.to_i
            when 'encrypted'
              @response[name] = (value == 'true')
            end
          end
        end
      end
    end
  end
end
