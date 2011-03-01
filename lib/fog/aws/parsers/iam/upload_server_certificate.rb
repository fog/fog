module Fog
  module Parsers
    module AWS
      module IAM

        class UploadServerCertificate < Fog::Parsers::Base

          def reset
            @response = { 'Certificate' => {} }
          end

          def end_element(name)
            case name
            when 'Arn', 'Path', 'ServerCertificateId', 'ServerCertificateName', 'UploadDate'
              @response['Certificate'][name] = @value
            when 'RequestId'
              @response[name] = @value
            end
          end

        end

      end
    end
  end
end
