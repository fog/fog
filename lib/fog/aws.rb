require File.dirname(__FILE__) + '/aws/simpledb'
require File.dirname(__FILE__) + '/aws/s3'

require 'rubygems'
require 'eventmachine'
require 'uri'

module Fog
  module AWS
    class Connection < EventMachine::Connection
      include EventMachine::Deferrable

      attr_accessor :body, :headers, :method, :parser, :url
      attr_reader :response

      def post_init
        @body ||= nil
        @data ||= nil
        @headers ||= {}
        @method ||= 'GET'
        @parser ||= nil
        @response ||= Fog::AWS::Response.new
      end

      def connection_completed
        uri = URI.parse(@url)
        start_tls if uri.scheme == 'https'
        request
      end

      def request
        uri = URI.parse(@url)
        path  = "#{uri.path}"
        path << "?#{uri.query}" if uri.query
        host  = "#{uri.host}"
        host << ":#{uri.port}" unless uri.port == 80
        @headers.merge!({'Host' => host})
        request  = "#{method} #{path} HTTP/1.1\r\n"
        for key, value in headers
          request << "#{key}: #{value}\r\n"
        end
        request << "\r\n#{@body}" if @body
        request << "\r\n"
        send_data(request)
      end

      def receive_data(data)
        # p data
        unless @data
          if data =~ /\AHTTP\/1\.[01] ([\d]{3})/
            @response.status = $1.to_i
          else
            @response.status = 0
          end
          @headers, @data = data.split("\r\n\r\n")
          for header in @headers.split("\r\n")
            if data = header.match(/(.*):\s(.*)/)
              @response.headers[data[1]] = data[2]
            end
          end
          if @parser && @data
            Nokogiri::XML::SAX::Parser.new(@parser).parse(@data.split(/<\?xml.*\?>/)[1])
            @response.body = @parser.response
          elsif @data
            @response.body = @data
          end
          set_deferred_status(:succeeded, self)
          EventMachine.stop_event_loop
        end
      end
    end

    class Response
      attr_accessor :status, :headers, :body

      def initialize
        @headers = {}
      end
    end

  end
end
