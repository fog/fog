module Fog
  module AWS
    class SimpleDB

      if Fog.mocking?
        def self.reset_data
          @data = { :domains => {} }
        end
        def self.data
          @data
        end
      end

      def self.reload
        current_directory = File.dirname(__FILE__)
        load "#{current_directory}/../connection.rb"
        load "#{current_directory}/../parser.rb"
        load "#{current_directory}/../response.rb"

        parsers_directory = "#{current_directory}/parsers/simpledb"
        load "#{parsers_directory}/basic.rb"
        load "#{parsers_directory}/domain_metadata.rb"
        load "#{parsers_directory}/get_attributes.rb"
        load "#{parsers_directory}/list_domains.rb"
        load "#{parsers_directory}/select.rb"

        requests_directory = "#{current_directory}/requests/simpledb"
        load "#{requests_directory}/batch_put_attributes.rb"
        load "#{requests_directory}/create_domain.rb"
        load "#{requests_directory}/delete_attributes.rb"
        load "#{requests_directory}/delete_domain.rb"
        load "#{requests_directory}/domain_metadata.rb"
        load "#{requests_directory}/get_attributes.rb"
        load "#{requests_directory}/list_domains.rb"
        load "#{requests_directory}/put_attributes.rb"
        load "#{requests_directory}/select.rb"

        if Fog.mocking?
          reset_data
        end
      end

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
        @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")
      end

      private

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
          :expects => 200,
          :headers => { 'Content-Type' => 'application/x-www-form-urlencoded' },
          :host => @host,
          :method => 'POST',
          :parser => parser
        })

        response
      end

      def sdb_encode(value)
        if value.nil?
          @nil_string
        else
          value.to_s
        end
      end

    end
  end
end

Fog::AWS::SimpleDB.reload
