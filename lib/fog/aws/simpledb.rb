require 'rubygems'
require 'base64'
require 'cgi'
require 'hmac-sha2'

require File.dirname(__FILE__) + '/simpledb/parsers'

module Fog
  module AWS
    class SimpleDB

      # Initialize connection to SimpleDB
      #
      # ==== Notes
      # options parameter must include values for :aws_access_key_id and 
      # :aws_secret_access_key in order to create a connection
      #
      # ==== Examples
      #   sdb = SimpleDB.new(
      #     :aws_access_key_id => your_aws_access_key_id,
      #     :aws_secret_access_key => your_aws_secret_access_key
      #   )
      #
      # ==== Parameters
      # * options<~Hash> - config arguments for connection.  Defaults to {}.
      #
      # ==== Returns
      # * SimpleDB object with connection to aws.
      def initialize(options={})
        @aws_access_key_id      = options[:aws_access_key_id]
        @aws_secret_access_key  = options[:aws_secret_access_key]
        @hmac       = HMAC::SHA256.new(@aws_secret_access_key)
        @host       = options[:host]      || 'sdb.amazonaws.com'
        @nil_string = options[:nil_string]|| 'nil'
        @port       = options[:port]      || 443
        @scheme     = options[:scheme]    || 'https'
        @connection = AWS::Connection.new("#{@scheme}://#{@host}:#{@port}")
      end

      # Create a SimpleDB domain
      #
      # ==== Parameters
      # * domain_name<~String>:: Name of domain. Must be between 3 and 255 of the
      # following characters: a-z, A-Z, 0-9, '_', '-' and '.'.
      # 
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :box_usage
      #     * :request_id
      def create_domain(domain_name)
        request({
          'Action' => 'CreateDomain',
          'DomainName' => domain_name
        }, Fog::Parsers::AWS::SimpleDB::BasicParser.new(@nil_string))
      end

      # Delete a SimpleDB domain
      #
      # ==== Parameters
      # * domain_name<~String>:: Name of domain. Must be between 3 and 255 of the
      # following characters: a-z, A-Z, 0-9, '_', '-' and '.'.
      # 
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :box_usage
      #     * :request_id
      def delete_domain(domain_name)
        request({
          'Action' => 'DeleteDomain',
          'DomainName' => domain_name
        }, Fog::Parsers::AWS::SimpleDB::BasicParser.new(@nil_string))
      end

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
        }, Fog::Parsers::AWS::SimpleDB::ListDomainsParser.new(@nil_string))
      end

      # List metadata for SimpleDB domain
      #
      # ==== Parameters
      # * domain_name<~String> - Name of domain. Must be between 3 and 255 of the
      # following characters: a-z, A-Z, 0-9, '_', '-' and '.'.
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :attribute_name_count - number of unique attribute names in domain
      #     * :attribute_names_size_bytes - total size of unique attribute names, in bytes
      #     * :attribute_value_count - number of all name/value pairs in domain
      #     * :attribute_values_size_bytes - total size of attributes, in bytes
      #     * :item_count - number of items in domain
      #     * :item_name_size_bytes - total size of item names in domain, in bytes
      #     * :timestamp - last update time for metadata.
      def domain_metadata(domain_name)
        request({
          'Action' => 'DomainMetadata',
          'DomainName' => domain_name
        }, Fog::Parsers::AWS::SimpleDB::DomainMetadataParser.new(@nil_string))
      end

      # Put items attributes into a SimpleDB domain
      #
      # ==== Parameters
      # * domain_name<~String> - Name of domain. Must be between 3 and 255 of the
      #   following characters: a-z, A-Z, 0-9, '_', '-' and '.'.
      # * items<~Hash> - Keys are the items names and may use any UTF-8
      #   characters valid in xml.  Control characters and sequences not allowed
      #   in xml are not valid.  Can be up to 1024 bytes long.  Values are the
      #   attributes to add to the given item and may use any UTF-8 characters
      #   valid in xml. Control characters and sequences not allowed in xml are
      #   not valid.  Each name and value can be up to 1024 bytes long.
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :box_usage
      #     * :request_id
      def batch_put_attributes(domain_name, items, replace_attributes = Hash.new([]))
        request({
          'Action' => 'BatchPutAttributes',
          'DomainName' => domain_name
        }.merge!(encode_batch_attributes(items, replace_attributes)), Fog::Parsers::AWS::SimpleDB::BasicParser.new(@nil_string))
      end

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
      #     * :box_usage
      #     * :request_id
      def delete_attributes(domain_name, item_name, attributes = nil)
        request({
          'Action' => 'DeleteAttributes',
          'DomainName' => domain_name,
          'ItemName' => item_name
        }.merge!(encode_attributes(attributes)), Fog::Parsers::AWS::SimpleDB::BasicParser.new(@nil_string))
      end

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
        }.merge!(encode_attribute_names(attributes)), Fog::Parsers::AWS::SimpleDB::GetAttributesParser.new(@nil_string))
      end

      # Select item data from SimpleDB
      #
      # ==== Parameters
      # * select_expression<~String> - Expression to query domain with.
      # * next_token<~String> - Offset token to start list, defaults to nil.
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :box_usage
      #     * :request_id
      #     * :items - list of attribute name/values for the items formatted as 
      #       { 'item_name' => { 'attribute_name' => ['attribute_value'] }}
      #     * :next_token - offset to start with if there are are more domains to list
      def select(select_expression, next_token = nil)
        request({
          'Action' => 'Select',
          'NextToken' => next_token,
          'SelectExpression' => select_expression
        }, Fog::Parsers::AWS::SimpleDB::SelectParser.new(@nil_string))
      end

      private

      def encode_batch_attributes(items, replace_attributes = Hash.new([]))
        encoded_attributes = {}
        if items
          item_index = 0
          for item_key in items.keys
            encoded_attributes["Item.#{item_index}.ItemName"] = item_key.to_s
            for attribute_key in items[item_key].keys
              attribute_index = 0
              for value in Array(items[item_key][attribute_key])
                encoded_attributes["Item.#{item_index}.Attribute.#{attribute_index}.Name"] = attribute_key.to_s
                if replace_attributes[item_key].include?(attribute_key)
                  encoded_attributes["Item.#{item_index}.Attribute.#{attribute_index}.Replace"] = 'true'
                end
                encoded_attributes["Item.#{item_index}.Attribute.#{attribute_index}.Value"] = sdb_encode(value)
                attribute_index += 1
              end
              item_index += 1
            end
          end
        end
        encoded_attributes
      end

      def encode_attributes(attributes, replace_attributes = [])
        encoded_attributes = {}
        if attributes
          index = 0
          for key in attributes.keys
            for value in Array(attributes[key])
              encoded_attributes["Attribute.#{index}.Name"] = key.to_s
              if replace_attributes.include?(key)
                encoded_attributes["Attribute.#{index}.Replace"] = 'true'
              end
              encoded_attributes["Attribute.#{index}.Value"] = sdb_encode(value)
              index += 1
            end
          end
        end
        encoded_attributes
      end

      def encode_attribute_names(attributes)
        encoded_attribute_names = {}
        if attributes
          index = 0
          for attribute in attributes
            encoded_attribute_names["AttributeName.#{index}"] = attribute.to_s
            index += 1
          end
        end
        encoded_attribute_names
      end

      def sdb_encode(value)
        if value.nil?
          @nil_string
        else
          value.to_s
        end
      end

      def request(params, parser)
        params.merge!({
          'AWSAccessKeyId' => @aws_access_key_id,
          'SignatureMethod' => 'HmacSHA256',
          'SignatureVersion' => '2',
          'Timestamp' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
          'Version' => '2007-11-07'
        })

        body = ''
        for key in params.keys.sort
          unless (value = params[key]).nil?
            body << "#{key}=#{CGI.escape(value.to_s).gsub(/\+/, '%20')}&"
          end
        end

        string_to_sign = "POST\n#{@host}\n/\n" << body.chop
        hmac = @hmac.update(string_to_sign)
        body << "Signature=#{CGI.escape(Base64.encode64(hmac.digest).chomp!).gsub(/\+/, '%20')}"

        response = @connection.request({
          :body => body,
          :headers => { 'Content-Type' => 'application/x-www-form-urlencoded' },
          :host => @host,
          :method => 'POST'
        })

        if parser && !response.body.empty?
          Nokogiri::XML::SAX::Parser.new(parser).parse(response.body.split(/<\?xml.*\?>/)[1])
          response.body = parser.response
        end

        response
      end

    end
  end
end
