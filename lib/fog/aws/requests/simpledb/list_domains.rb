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
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'BoxUsage'
      #     * 'Domains' - array of domain names.
      #     * 'NextToken' - offset to start with if there are are more domains to list
      #     * 'RequestId'
      def list_domains(options = {})
        request({
          'Action' => 'ListDomains',
          'MaxNumberOfDomains' => options['MaxNumberOfDomains'],
          'NextToken' => options['NextToken']
        }, Fog::Parsers::AWS::SimpleDB::ListDomains.new(@nil_string))
      end

    end
  end
end
