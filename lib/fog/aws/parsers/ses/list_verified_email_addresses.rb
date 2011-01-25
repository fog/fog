module Fog
  module Parsers
    module AWS
      module SES

        class ListVerifiedEmailAddresses < Fog::Parsers::Base

          def reset
            @response = { 'ListVerifiedEmailAddressesResult' => { 'VerifiedEmailAddresses' => [] }, 'ResponseMetadata' => {} }
          end

          def end_element(name)
            case name
            when 'member'
              @response['ListVerifiedEmailAddressesResult']['VerifiedEmailAddresses'] << @value
            when 'RequestId'
              @response['ResponseMetadata'][name] = @value
            end
          end
        end

      end
    end
  end
end
