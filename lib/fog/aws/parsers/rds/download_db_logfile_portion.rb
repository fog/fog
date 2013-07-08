module Fog
  module Parsers
    module AWS
      module RDS

        class DownloadDBLogFilePortion < Fog::Parsers::Base

          def reset
            @response = { 'DownloadDBLogFilePortionResult' => {}, 'ResponseMetadata' => {} }
          end

          def start_element(name, attrs = [])
            super
          end

          def end_element(name)
            case name
            when 'LogFileData' then @response['DownloadDBLogFilePortionResult'][name] = value
            when 'AdditionalDataPending' then @response['DownloadDBLogFilePortionResult'][name] = value
            when 'Marker' then @response['DownloadDBLogFilePortionResult'][name] = value
            when 'RequestId' then @response['ResponseMetadata'][name] = value
            end
          end
        end
      end
    end
  end
end
