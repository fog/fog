module Fog
  module AWS
    class SimpleDB

      # List metadata for SimpleDB domain
      #
      # ==== Parameters
      # * domain_name<~String> - Name of domain. Must be between 3 and 255 of the
      # following characters: a-z, A-Z, 0-9, '_', '-' and '.'.
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'AttributeNameCount' - number of unique attribute names in domain
      #     * 'AttributeNamesSizeBytes' - total size of unique attribute names, in bytes
      #     * 'AttributeValueCount' - number of all name/value pairs in domain
      #     * 'AttributeValuesSizeBytes' - total size of attributes, in bytes
      #     * 'ItemCount' - number of items in domain
      #     * 'ItemNameSizeBytes' - total size of item names in domain, in bytes
      #     * 'Timestamp' - last update time for metadata.
      def domain_metadata(domain_name)
        request({
          'Action' => 'DomainMetadata',
          'DomainName' => domain_name
        }, Fog::Parsers::AWS::SimpleDB::DomainMetadata.new(@nil_string))
      end

    end
  end
end
