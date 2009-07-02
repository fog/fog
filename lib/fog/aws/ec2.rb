require 'rubygems'
require 'base64'
require 'cgi'
require 'hmac-sha2'

require File.dirname(__FILE__) + '/ec2/parsers'

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
      # sdb = SimpleDB.new(
      #  :aws_access_key_id => your_aws_access_key_id,
      #  :aws_secret_access_key => your_aws_secret_access_key
      # )
      #
      # ==== Parameters
      # options<~Hash>:: config arguments for connection.  Defaults to {}.
      #
      # ==== Returns
      # SimpleDB object with connection to aws.
      def initialize(options={})
        @aws_access_key_id      = options[:aws_access_key_id]
        @aws_secret_access_key  = options[:aws_secret_access_key]
        @hmac       = HMAC::SHA256.new(@aws_secret_access_key)
        @host       = options[:host]      || 'ec2.amazonaws.com'
        @port       = options[:port]      || 443
        @scheme     = options[:scheme]    || 'https'
        @connection = AWS::Connection.new("#{@scheme}://#{@host}:#{@port}")
      end

      # Acquire an elastic IP address.
      #
      # ==== Returns
      # Hash:: The acquired :public_ip address.
      def allocate_address
        request({
          'Action' => 'AllocateAddress'
        }, Fog::Parsers::AWS::EC2::AllocateAddress.new)
      end

      def describe_addresses(public_ips = [])
        params, index = {}, 1
        for public_ip in [*public_ips]
          params["PublicIp.#{index}"] = public_ip
          index += 1
        end
        request({
          'Action' => 'DescribeAddresses'
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeAddresses.new)
      end

      # Release an elastic IP address.
      #
      # ==== Returns
      # Hash:: :return success boolean
      def release_address(public_ip)
        request({
          'Action' => 'ReleaseAddress',
          'PublicIp' => public_ip
        }, Fog::Parsers::AWS::EC2::ReleaseAddress.new)
      end

      private

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
            body << "#{key}=#{CGI.escape(value).gsub(/\+/, '%20')}&"
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
