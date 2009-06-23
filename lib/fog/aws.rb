require File.dirname(__FILE__) + '/aws/simpledb'
require File.dirname(__FILE__) + '/aws/s3'

require 'rubygems'
require 'openssl'
require 'socket'
require 'uri'

module Fog
  module AWS
    class Connection

      def initialize(url)
        @uri = URI.parse(url)
        @connection = TCPSocket.open(@uri.host, @uri.port)
        if @uri.scheme == 'https'
          @ssl_context = OpenSSL::SSL::SSLContext.new
          @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
          @connection = OpenSSL::SSL::SSLSocket.new(@connection, @ssl_context)
          @connection.sync_close = true
          @connection.connect
        end
      end

      def request(params)
        uri = URI.parse(params[:url])
        path = "#{uri.path}"
        if uri.query
          path << "?#{uri.query}"
        end
        host = "#{uri.host}"
        if (uri.scheme == "http" && uri.port != 80) ||
           (uri.scheme == 'https' && uri.port != 443)
          host << ":#{uri.port}"
        end

        request = "#{params[:method]} #{path} HTTP/1.1\r\n"
        params[:headers] ||= {}
        params[:headers]['Host'] = uri.host
        if params[:body]
          params[:headers]['Content-Length'] = params[:body].length
        end
        for key, value in params[:headers]
          request << "#{key}: #{value}\r\n"
        end
        request << "\r\n#{params[:body]}"
        @connection.write(request)

        response = AWS::Response.new
        response.status = @connection.readline[9..11].to_i
        while true
          data = @connection.readline[0..-3]
          if data == ""
            break
          end
          header = data.split(': ')
          response.headers[header[0]] = header[1]
        end
        if response.headers['Content-Length']
          content_length = response.headers['Content-Length'].to_i
          response.body << @connection.read(content_length)
        elsif response.headers['Transfer-Encoding'] == 'chunked'
          while true
            @connection.readline =~ /([a-f0-9]*)\r\n/i
            chunk_size = $1.to_i(16) + 2  # 2 = "/r/n".length
            response.body << @connection.read(chunk_size)
            if $1.to_i(16) == 0
              break
            end
          end
        end
        response
      end

    end

    class Response

      attr_accessor :status, :headers, :body

      def initialize
        @body = ''
        @headers = {}
      end

    end


  end
end
