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
      # * response<~Fog::AWS::Response>:
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
