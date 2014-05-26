module Fog
  module Parsers
    module DNS
      module AWS
        class DeleteHostedZone < Fog::Parsers::Base
          def reset
            @response = {}
            @response['ChangeInfo'] = {}
          end

          def end_element(name)
            case name
            when 'Id', 'Status', 'SubmittedAt'
              @response['ChangeInfo'][name] = value
            end
          end
        end
      end
    end
  end
end
