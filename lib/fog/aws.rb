require File.dirname(__FILE__) + '/aws/simpledb'
require File.dirname(__FILE__) + '/aws/s3'

require 'rubygems'
require 'eventmachine'
require 'uri'

module Fog
  module AWS
    class Connection < EventMachine::Connection
      include EventMachine::Deferrable

      attr_accessor :headers, :method, :url, :parser
      attr_reader :response

      def post_init
        @data ||= nil
        @headers ||= {}
        @response ||= Fog::AWS::Response.new
      end

      def connection_completed
        uri = URI.parse(@url)
        if uri.scheme == 'https'
          start_tls
        else
          request
        end
      end

      def ssl_handshake_completed
        request
      end

      def request
        uri = URI.parse(@url)
        path = "#{uri.path}#{uri.query.nil? ? "" : "?#{uri.query}"}"
        host = "#{uri.host}#{uri.port == 80 ? "" : ":#{uri.port}"}"
        @headers.merge!({'Host' => host})
        send_data("#{method} #{path} HTTP/1.1\r\n#{headers.collect {|k,v| "#{k}: #{v}\r\n"}.join('')}\r\n")
      end

      def receive_data(data)
        p data
        unless @data
          if data =~ /\AHTTP\/1\.[01] ([\d]{3})/
            @response.status = $1.to_i
          else
            @response.status = 0
          end
          @headers, @data = data.split(/<\?xml.*\?>/)
          @headers.split("\r\n").each do |header|
            if data = header.match(/(.*):\s(.*)/)
              @response.headers[data[1]] = data[2]
            end
          end
          if @data
            Nokogiri::XML::SAX::Parser.new(@parser).parse(@data)
            @response.body = @parser.response
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