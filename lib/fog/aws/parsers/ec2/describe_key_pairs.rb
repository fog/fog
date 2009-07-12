module Fog
  module Parsers
    module AWS
      module EC2

        class DescribeKeyPairs < Fog::Parsers::Base

          def reset
            @key = {}
            @response = { :key_set => [] }
          end

          def end_element(name)
            case name
            when 'item'
              @response[:key_set] << @key
              @key = {}
            when 'keyFingerprint'
              @key[:key_fingerprint] = @value
            when 'keyName'
              @key[:key_name] = @value
            when 'requestId'
              @response[:request_id] = @value
            end
          end

        end

      end
    end
  end
end
