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
        # * attributes<~Array> - Attributes to return from the item.  Defaults to
        #   nil, which will return all attributes. Attribute names and values may use
        #   any UTF-8 characters valid in xml. Control characters and sequences not 
        #   allowed in xml are not valid.  Each name and value can be up to 1024
        #   bytes long.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'Attributes' - list of attribute name/values for the item
        #     * 'BoxUsage'
        #     * 'RequestId'
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

else

  module Fog
    module AWS
      class SimpleDB

        def get_attributes(domain_name, item_name, attributes = nil)
          response = Fog::Response.new
          if Fog::AWS::SimpleDB.data[:domains][domain_name]
            object = {}
            if attributes
              for attribute in attributes
                if Fog::AWS::SimpleDB.data[:domains][domain_name][item_name] && Fog::AWS::SimpleDB.data[:domains][domain_name][item_name]
                  object[attribute] = Fog::AWS::SimpleDB.data[:domains][domain_name][item_name][attribute]
                end
              end
            elsif Fog::AWS::SimpleDB.data[:domains][domain_name][item_name]
              object = Fog::AWS::SimpleDB.data[:domains][domain_name][item_name]
            end
            response.status = 200
            response.body = {
              'Attributes'  => object,
              'BoxUsage'    => Fog::AWS::Mock.box_usage,
              'RequestId'   => Fog::AWS::Mock.request_id
            }
          else
            response.status = 400
            raise(Excon::Errors.status_error(200, 400, response))
          end
          response
        end

      end
    end
  end

end
