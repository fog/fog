require 'rubygems'
require 'base64'
require 'cgi'
require 'hmac-sha2'

current_directory = File.dirname(__FILE__)
require "#{current_directory}/../connection"
require "#{current_directory}/../parser"
require "#{current_directory}/../response"

parsers_directory = "#{current_directory}/parsers/ec2"
require "#{parsers_directory}/allocate_address"
require "#{parsers_directory}/basic"
require "#{parsers_directory}/create_key_pair"
require "#{parsers_directory}/create_snapshot"
require "#{parsers_directory}/create_volume"
require "#{parsers_directory}/describe_addresses"
require "#{parsers_directory}/describe_availability_zones"
require "#{parsers_directory}/describe_images"
require "#{parsers_directory}/describe_instances"
require "#{parsers_directory}/describe_key_pairs"
require "#{parsers_directory}/describe_security_groups"
require "#{parsers_directory}/describe_snapshots"
require "#{parsers_directory}/describe_volumes"
require "#{parsers_directory}/run_instances"
require "#{parsers_directory}/terminate_instances"

requests_directory = "#{current_directory}/requests/ec2"
require "#{requests_directory}/allocate_address"
require "#{requests_directory}/create_key_pair"
require "#{requests_directory}/create_security_group"
require "#{requests_directory}/create_snapshot"
require "#{requests_directory}/create_volume"
require "#{requests_directory}/delete_key_pair"
require "#{requests_directory}/delete_security_group"
require "#{requests_directory}/delete_snapshot"
require "#{requests_directory}/delete_volume"
require "#{requests_directory}/describe_addresses"
require "#{requests_directory}/describe_availability_zones"
require "#{requests_directory}/describe_images"
require "#{requests_directory}/describe_instances"
require "#{requests_directory}/describe_key_pairs"
require "#{requests_directory}/describe_security_groups"
require "#{requests_directory}/describe_snapshots"
require "#{requests_directory}/describe_volumes"
require "#{requests_directory}/release_address"
require "#{requests_directory}/run_instances"
require "#{requests_directory}/terminate_instances"


module Fog
  module AWS
    class EC2

      # Initialize connection to EC2
      #
      # ==== Notes
      # options parameter must include values for :aws_access_key_id and 
      # :aws_secret_access_key in order to create a connection
      #
      # ==== Examples
      #   sdb = SimpleDB.new(
      #    :aws_access_key_id => your_aws_access_key_id,
      #    :aws_secret_access_key => your_aws_secret_access_key
      #   )
      #
      # ==== Parameters
      # * options<~Hash> - config arguments for connection.  Defaults to {}.
      #
      # ==== Returns
      # * EC2 object with connection to aws.
      def initialize(options={})
        @aws_access_key_id      = options[:aws_access_key_id]
        @aws_secret_access_key  = options[:aws_secret_access_key]
        @hmac       = HMAC::SHA256.new(@aws_secret_access_key)
        @host       = options[:host]      || 'ec2.amazonaws.com'
        @port       = options[:port]      || 443
        @scheme     = options[:scheme]    || 'https'
        @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")
      end

      private

      def indexed_params(name, params)
        indexed, index = {}, 1
        for param in [*params]
          indexed["#{name}.#{index}"] = param
          index += 1
        end
        indexed
      end

      def request(params, parser)
        params.merge!({
          'AWSAccessKeyId' => @aws_access_key_id,
          'SignatureMethod' => 'HmacSHA256',
          'SignatureVersion' => '2',
          'Timestamp' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
          'Version' => '2009-04-04'
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

    end
  end
end
