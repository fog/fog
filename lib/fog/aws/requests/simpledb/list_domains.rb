unless Fog.mocking?

  module Fog
    module AWS
      class SimpleDB

        # List SimpleDB domains
        #
        # ==== Parameters
        # * options<~Hash> - options, defaults to {}
        #   * 'MaxNumberOfDomains'<~Integer> - number of domains to return
        #     between 1 and 100, defaults to 100
        #   * 'NextToken'<~String> - Offset token to start listing, defaults to nil
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'BoxUsage'
        #     * 'Domains' - array of domain names.
        #     * 'NextToken' - offset to start with if there are are more domains to list
        #     * 'RequestId'
        def list_domains(options = {})
          request({
            'Action' => 'ListDomains'
          }.merge!(options), Fog::Parsers::AWS::SimpleDB::ListDomains.new(@nil_string))
        end

      end
    end
  end

else

  module Fog
    module AWS
      class SimpleDB

        def list_domains(options = {})
          response = Excon::Response.new
          keys = Fog::AWS::SimpleDB.data[:domains].keys
          max = options['MaxNumberOfDomains'] || keys.size
          offset = options['NextToken'] || 0
          domains = []
          for key, value in Fog::AWS::SimpleDB.data[:domains].keys[offset...max]
            domains << key
          end
          response.status = 200
          response.body = {
            'BoxUsage'  => Fog::AWS::Mock.box_usage,
            'Domains'   => domains,
            'RequestId' => Fog::AWS::Mock.request_id
          }
          if max < keys.size
            response.body['NextToken'] = max + 1
          end
          response
        end

      end
    end
  end

end
