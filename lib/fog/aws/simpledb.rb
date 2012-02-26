require File.expand_path(File.join(File.dirname(__FILE__), '..', 'aws'))

module Fog
  module AWS
    class SimpleDB < Fog::Service

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :host, :nil_string, :path, :port, :scheme, :persistent, :region, :aws_session_token

      request_path 'fog/aws/requests/simpledb'
      request :batch_put_attributes
      request :create_domain
      request :delete_attributes
      request :delete_domain
      request :domain_metadata
      request :get_attributes
      request :list_domains
      request :put_attributes
      request :select

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :domains => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @aws_access_key_id = options[:aws_access_key_id]
        end

        def data
          self.class.data[@aws_access_key_id]
        end

        def reset_data
          self.class.data.delete(@aws_access_key_id)
        end

      end

      class Real

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
          require 'fog/core/parser'

          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @aws_session_token      = options[:aws_session_token]
          @connection_options     = options[:connection_options] || {}
          @hmac       = Fog::HMAC.new('sha256', @aws_secret_access_key)
          @nil_string = options[:nil_string]|| 'nil'

          options[:region] ||= 'us-east-1'
          @host = options[:host] || "sdb.#{options[:region]}.amazonaws.com"
          @path       = options[:path]        || '/'
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
        end

        private

        def encode_attributes(attributes, replace_attributes = [], expected_attributes = {})
          encoded_attributes = {}
          if attributes

            expected_attributes.keys.each_with_index do |exkey, index|
              for value in Array(expected_attributes[exkey])
                encoded_attributes["Expected.#{index}.Name"] = exkey.to_s
                encoded_attributes["Expected.#{index}.Value"] = sdb_encode(value)
              end
            end

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
          Fog::AWS.indexed_param('AttributeName', attributes.map {|attribute| attributes.to_s})
        end

        def encode_batch_attributes(items, replace_attributes = Hash.new([]))
          encoded_attributes = {}
          if items
            item_index = 0
            for item_key in items.keys
              encoded_attributes["Item.#{item_index}.ItemName"] = item_key.to_s
              attribute_index = 0
              for attribute_key in items[item_key].keys
                for value in Array(items[item_key][attribute_key])
                  encoded_attributes["Item.#{item_index}.Attribute.#{attribute_index}.Name"] = attribute_key.to_s
                  if replace_attributes[item_key].include?(attribute_key)
                    encoded_attributes["Item.#{item_index}.Attribute.#{attribute_index}.Replace"] = 'true'
                  end
                  encoded_attributes["Item.#{item_index}.Attribute.#{attribute_index}.Value"] = sdb_encode(value)
                  attribute_index += 1
                end
              end
              item_index += 1
            end
          end
          encoded_attributes
        end

        def reload
          @connection.reset
        end

        def request(params)
          idempotent = params.delete(:idempotent)
          parser = params.delete(:parser)

          body = Fog::AWS.signed_params(
            params,
            {
              :aws_access_key_id  => @aws_access_key_id,
              :aws_session_token  => @aws_session_token,
              :hmac               => @hmac,
              :host               => @host,
              :path               => @path,
              :port               => @port,
              :version            => '2009-04-15'
            }
          )

          response = @connection.request({
            :body       => body,
            :expects    => 200,
            :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded; charset=utf-8' },
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
