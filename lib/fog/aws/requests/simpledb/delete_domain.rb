unless Fog.mocking?

  module Fog
    module AWS
      class SimpleDB

        # Delete a SimpleDB domain
        #
        # ==== Parameters
        # * domain_name<~String>:: Name of domain. Must be between 3 and 255 of the
        # following characters: a-z, A-Z, 0-9, '_', '-' and '.'.
        # 
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'BoxUsage'
        #     * 'RequestId'
        def delete_domain(domain_name)
          request({
            'Action' => 'DeleteDomain',
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

        def delete_domain(domain_name)
          response = Excon::Response.new
          if Fog::AWS::SimpleDB.data[:domains].delete(domain_name)
            response.status = 200
            response.body = {
              'BoxUsage'  => Fog::AWS::Mock.box_usage,
              'RequestId' => Fog::AWS::Mock.request_id
            }
          end
          response
        end

      end
    end
  end

end
