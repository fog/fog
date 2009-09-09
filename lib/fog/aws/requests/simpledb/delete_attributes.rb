unless Fog.mocking?

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
        # * attributes<~Hash> - Name/value pairs to remove from the item.  Defaults to
        #   nil, which will delete the entire item. Attribute names and values may
        #   use any UTF-8 characters valid in xml. Control characters and sequences
        #   not allowed in xml are not valid.  Each name and value can be up to 1024
        #   bytes long.
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #     * 'BoxUsage'
        #     * 'RequestId'
        def delete_attributes(domain_name, item_name, attributes = nil)
          request({
            'Action' => 'DeleteAttributes',
            'DomainName' => domain_name,
            'ItemName' => item_name
          }.merge!(encode_attributes(attributes)), Fog::Parsers::AWS::SimpleDB::Basic.new(@nil_string))
        end

      end
    end
  end

else

  module Fog
    module AWS
      class SimpleDB

        def delete_attributes(domain_name, item_name, attributes = nil)
          response = Fog::Response.new
          if Fog::AWS::SimpleDB.data[:domains][domain_name]
            if attributes
              for key, value in attributes
                if Fog::AWS::SimpleDB.data[:domains][domain_name][key]
                  Fog::AWS::SimpleDB.data[:domains][domain_name][key].delete('value')
                end
              end
            else
              Fog::AWS::SimpleDB.data[:domains].delete(domain_name)
            end
            response.status = 200
            response.body = {
              'BoxUsage'  => Fog::AWS::Mock.box_usage,
              'RequestId' => Fog::AWS::Mock.request_id
            }
          else
            response.status = 400
            raise(Fog::Errors.status_error(200, 400, response))
          end
          response
        end

      end
    end
  end

end