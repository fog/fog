module Fog
  module AWS
    class SimpleDB

      # Put item attributes into a SimpleDB domain
      #
      # ==== Parameters
      # * domain_name<~String> - Name of domain. Must be between 3 and 255 of the
      # following characters: a-z, A-Z, 0-9, '_', '-' and '.'.
      # * item_name<~String> - Name of the item.  May use any UTF-8 characters valid
      #   in xml.  Control characters and sequences not allowed in xml are not
      #   valid.  Can be up to 1024 bytes long.
      # * attributes<~Hash> - Name/value pairs to add to the item.  Attribute names
      #   and values may use any UTF-8 characters valid in xml. Control characters
      #   and sequences not allowed in xml are not valid.  Each name and value can
      #   be up to 1024 bytes long.
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :box_usage
      #     * :request_id
      def put_attributes(domain_name, item_name, attributes, replace_attributes = [])
        batch_put_attributes(domain_name, { item_name => attributes }, { item_name => replace_attributes })
      end

    end
  end
end
