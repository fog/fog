module Fog
  module Parsers
    module Storage
      module AWS

        class GetBucketWebsite < Fog::Parsers::Base

          def reset
            @response = { 'ErrorDocument' => {}, 'IndexDocument' => {} }
          end

          def end_element(name)
            case name
            when 'Key'
              @response['ErrorDocument'][name] = value
            when 'Suffix'
              @response['IndexDocument'][name] = value
            end
          end

        end

      end
    end
  end
end
