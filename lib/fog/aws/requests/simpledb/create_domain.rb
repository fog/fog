unless Fog.mocking?

  module Fog
    module AWS
      class SimpleDB

        # Create a SimpleDB domain
        #
        # ==== Parameters
        # * domain_name<~String>:: Name of domain. Must be between 3 and 255 of the
        # following characters: a-z, A-Z, 0-9, '_', '-' and '.'.
        # 
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #     * 'BoxUsage'
        #     * 'RequestId'
        def create_domain(domain_name)
          request({
            'Action' => 'CreateDomain',
            'DomainName' => domain_name
          }, Fog::Parsers::AWS::SimpleDB::Basic.new(@nil_string))
        end

      end
    end
  end

else

  module Fog
    module AWS
      class SimpleDB

        def create_domain(domain_name)
          response = Fog::Response.new
          Fog::AWS::SimpleDB.data[:domains][domain_name] = {}
          response.status = 200
          response.body = {
            'BoxUsage'  => Fog::AWS::Mock.box_usage,
            'RequestId' => Fog::AWS::Mock.request_id
          }
          response
        end

      end
    end
  end

end
