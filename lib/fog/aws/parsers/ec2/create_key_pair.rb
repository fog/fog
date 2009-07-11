require File.dirname(__FILE__) + '/basic'

module Fog
  module Parsers
    module AWS
      module EC2

        class CreateKeyPair < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'keyFingerprint'
              @response[:key_fingerprint] = @value
            when 'keyMaterial'
              @response[:key_material] = @value
            when 'keyName'
              @response[:key_name] = @value
            when 'requestId'
              @response[:request_id] = @value
            end
          end

        end

      end
    end
  end
end
