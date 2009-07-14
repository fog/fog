module Fog
  module AWS
    class SimpleDB

      # List SimpleDB domains
      #
      # ==== Parameters
      # * options<~Hash> - options, defaults to {}
      #   *max_number_of_domains<~Integer> - number of domains to return
      #     between 1 and 100, defaults to 100
      #   *next_token<~String> - Offset token to start listing, defaults to nil
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :box_usage
      #     * :request_id
      #     * :domains - array of domain names.
      #     * :next_token - offset to start with if there are are more domains to list
      def list_domains(options = {})
        request({
          'Action' => 'ListDomains',
          'MaxNumberOfDomains' => options[:max_number_of_domains],
          'NextToken' => options[:next_token]
        }, Fog::Parsers::AWS::SimpleDB::ListDomains.new(@nil_string))
      end

    end
  end
end
