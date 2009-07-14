module Fog
  module AWS
    class SimpleDB

      # List metadata for SimpleDB domain
      #
      # ==== Parameters
      # * domain_name<~String> - Name of domain. Must be between 3 and 255 of the
      #   following characters: a-z, A-Z, 0-9, '_', '-' and '.'.
      # * item_name<~String> - Name of the item.  May use any UTF-8 characters valid
      #   in xml.  Control characters and sequences not allowed in xml are not
      #   valid.  Can be up to 1024 bytes long.
      # * attributes<~Hash> - Name/value pairs to return from the item.  Defaults to
      #   nil, which will return all attributes. Attribute names and values may use
      #   any UTF-8 characters valid in xml. Control characters and sequences not 
      #   allowed in xml are not valid.  Each name and value can be up to 1024
      #   bytes long.
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :box_usage
      #     * :request_id
      #     * :attributes - list of attribute name/values for the item
      def get_attributes(domain_name, item_name, attributes = nil)
        request({
          'Action' => 'GetAttributes',
          'DomainName' => domain_name,
          'ItemName' => item_name,
        }.merge!(encode_attribute_names(attributes)), Fog::Parsers::AWS::SimpleDB::GetAttributes.new(@nil_string))
      end

    end
  end
end
