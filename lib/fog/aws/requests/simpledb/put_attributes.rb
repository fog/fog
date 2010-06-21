module Fog
  module AWS
    module SimpleDB
      class Real

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
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'BoxUsage'
        #     * 'RequestId'
        def put_attributes(domain_name, item_name, attributes, replace_attributes = [])
          request({
            'Action'      => 'PutAttributes',
            'DomainName'  => domain_name,
            :parser       => Fog::Parsers::AWS::SimpleDB::Basic.new(@nil_string),
            'ItemName' => item_name
          }.merge!(encode_attributes(attributes, replace_attributes, {})))
        end

        def put_conditional(domain_name, item_name, attributes, expected_attributes = {})
          request({
            'Action'      => 'PutAttributes',
            'DomainName'  => domain_name,
            :parser       => Fog::Parsers::AWS::SimpleDB::Basic.new(@nil_string),
            'ItemName' => item_name
          }.merge!(encode_attributes(attributes, expected_attributes.keys, expected_attributes)))
        end

      end

      class Mock

        def put_attributes(domain_name, item_name, attributes, replace_attributes = [])
          response = Excon::Response.new
# TODO: mock out replace_attributes support
          if @data[:domains][domain_name]
            attributes.each do |key, value|
              @data[:domains][domain_name][item_name] ||= {}
              @data[:domains][domain_name][item_name][key.to_s] = [value.to_s]
            end
            response.status = 200
            response.body = {
              'BoxUsage'  => Fog::AWS::Mock.box_usage,
              'RequestId' => Fog::AWS::Mock.request_id
            }
          else
            response.status = 400
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end

        def put_conditional(domain_name, item_name, attributes, expected_attributes = {})
          response = Excon::Response.new
          if @data[:domains][domain_name]
            expected_attributes.each do |ck, cv|
              if @data[:domains][domain_name][item_name][ck] != [cv]
                response.status = 409
                raise(Excon::Errors.status_error({:expects => 200}, response))
              end
            end
            attributes.each do |key, value|
              @data[:domains][domain_name][item_name] ||= {}
              @data[:domains][domain_name][item_name][key.to_s] = [value.to_s]
            end
            response.status = 200
            response.body = {
              'BoxUsage'  => Fog::AWS::Mock.box_usage,
              'RequestId' => Fog::AWS::Mock.request_id
            }
          else
            response.status = 400
            raise(Excon::Errors.status_error({:expects => 200}, response))

          end
          response
        end

      end
    end
  end
end
