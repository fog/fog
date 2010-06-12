module Fog
  module AWS
    module SimpleDB
      extend Fog::Service

      requires :aws_access_key_id, :aws_secret_access_key

      request_path 'fog/aws/requests/simpledb'
      request 'batch_put_attributes'
      request 'create_domain'
      request 'delete_attributes'
      request 'delete_domain'
      request 'domain_metadata'
      request 'get_attributes'
      request 'list_domains'
      request 'put_attributes'
      request 'select'

      class Mock
        include Collections

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :domains => {}
            }
          end
        end

        def self.reset_data(keys=data.keys)
          for key in [*keys]
            data.delete(key)
          end
        end

        def initialize(options={})
          @aws_access_key_id = options[:aws_access_key_id]
          @data = self.class.data[@aws_access_key_id]
        end

      end

      class Real
        include Collections

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
          AWS.indexed_param('AttributeName', attributes.map {|attribute| attributes.to_s})
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

        def request(params)
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")
          idempotent = params.delete(:idempotent)
          parser = params.delete(:parser)

          body = AWS.signed_params(
            params,
            {
              :aws_access_key_id  => @aws_access_key_id,
              :hmac               => @hmac,
              :host               => @host,
              :version            => '2007-11-07'
            }
          )

          response = @connection.request({
            :body       => body,
            :expects    => 200,
            :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
            :host       => @host,
            :idempotent => idempotent,
            :method     => 'POST',
            :parser     => parser
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
end
