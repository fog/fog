module Fog
  module Parsers
    module AWS
      module SimpleDB

        class ListDomains < Fog::Parsers::AWS::SimpleDB::Basic

          def reset
            @response = { :domains => [] }
          end

          def end_element(name)
            case(name)
            when 'BoxUsage'   then response[:box_usage] = @value.to_f
            when 'DomainName' then response[:domains] << @value
            when 'NextToken'  then response[:next_token] = @value
            when 'RequestId'  then response[:request_id] = @value
            end
          end

        end

      end
    end
  end
end