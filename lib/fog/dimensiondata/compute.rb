require 'fog/joyent/core'
require 'fog/joyent/errors'

module Fog
  module Compute
    class DimensionData < Fog::Service
      requires :dimensiondata_username

      recognizes :dimensiondata_password
      recognizes :dimensiondata_url

      secrets :dimensiondata_password

      model_path 'fog/dimensiondata/models/compute'
      request_path 'fog/dimensiondata/requests/compute'

      request :list_datacenters
      # request :get_datacenter

      # Datacenters
      collection :datacenters
      model :datacenter

      # Images
      collection :images
      model :image
      request :list_datasets
      request :get_dataset
      request :list_images
      request :get_image

      # Servers
      collection :servers
      model :server
      request :list_machines
      request :get_machine
      request :create_machine
      request :start_machine
      request :stop_machine
      request :reboot_machine
      request :resize_machine
      request :delete_machine

      # Networks
      collection :networks
      model :network
      request :list_networks

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def data
          self.class.data
        end

        def initialize(options = {})
          @dimensiondata_username = options[:dimensiondata_username]
          @dimensiondata_password = options[:dimensiondata_password]
        end

        def request(opts)
          raise "Not Implemented"
        end
      end # Mock

      class Real
        attr_accessor :dimensiondata_version
        attr_accessor :dimensiondata_url

        def initialize(options = {})
          @connection_options = options[:connection_options] || {}
          @persistent = options[:persistent] || false

          @dimensiondata_url = options[:dimensiondata_url] || 'https://api-na.dimensiondata.com'
          @dimensiondata_version = options[:dimensiondata_version] || '~2.1'
          @dimensiondata_username = options[:dimensiondata_username]

          unless @dimensiondata_username
            raise ArgumentError, "options[:dimensiondata_username] required"
          end

          if options[:dimensiondata_password]
            @dimensiondata_password = options[:dimensiondata_password]
            @header_method = method(:header_for_basic_auth)
          else
            raise ArgumentError, "Must provide a dimensiondata_password"
          end

          @connection = Fog::JSON::Connection.new(
            @dimensiondata_url,
            @persistent,
            @connection_options
          )

          account = @connection.request(
            :method => "GET",
            :path => "/oec/myaccount",
            :expects => [200]
          )

          @org_id = account.orgId
        end

        def request(opts = {})
          opts[:headers] = {
            "Content-Type" => "application/json",
            "Accept" => "application/json"
          }.merge(opts[:headers] || {}).merge(@header_method.call)

          if opts[:body]
            opts[:body] = Fog::JSON.encode(opts[:body])
          end

          response = @connection.request(opts)
          if response.headers["Content-Type"] == "application/json"
            response.body = json_decode(response.body)
          end

          response
        rescue Excon::Errors::HTTPStatusError => e
          if e.response.headers["Content-Type"] == "application/json"
            e.response.body = json_decode(e.response.body)
          end
          raise_if_error!(e.request, e.response)
        end

        private

        def json_decode(body)
          parsed = Fog::JSON.decode(body)
          decode_time_attrs(parsed)
        end

        def header_for_basic_auth
          {
            "Authorization" => "Basic #{Base64.encode64("#{@dimensiondata_username}:#{@dimensiondata_password}").delete("\r\n")}"
          }
        end

        def raise_if_error!(request, response)
          case response.status
          when 400 then
            raise DimensionData::Errors::BadRequest.new('Bad Request', request, response)
          when 401 then
            raise DimensionData::Errors::Unauthorized.new('Invalid credentials were used', request, response)
          when 403 then
            raise DimensionData::Errors::Forbidden.new('No permissions to the specified resource', request, response)
          when 404 then
            raise DimensionData::Errors::NotFound.new('Requested resource was not found', request, response)
          when 405 then
            raise DimensionData::Errors::MethodNotAllowed.new('Method not supported for the given resource', request, response)
          when 406 then
            raise DimensionData::Errors::NotAcceptable.new('Try sending a different Accept header', request, response)
          when 409 then
            raise DimensionData::Errors::Conflict.new('Most likely invalid or missing parameters', request, response)
          when 414 then
            raise DimensionData::Errors::RequestEntityTooLarge.new('You sent too much data', request, response)
          when 415 then
            raise DimensionData::Errors::UnsupportedMediaType.new('You encoded your request in a format we don\'t understand', request, response)
          when 420 then
            raise DimensionData::Errors::PolicyNotForfilled.new('You are sending too many requests', request, response)
          when 449 then
            raise DimensionData::Errors::RetryWith.new('Invalid API Version requested; try with a different API Version', request, response)
          when 503 then
            raise DimensionData::Errors::ServiceUnavailable.new('Either there\'s no capacity in this datacenter, or we\'re in a maintenance window', request, response)
          end
        end
      end # Real
    end
  end
end
