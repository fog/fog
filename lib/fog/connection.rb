require 'rubygems'
require 'openssl'
require 'socket'
require 'uri'

require "#{File.dirname(__FILE__)}/response"

unless Fog.mocking?

  module Fog
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

      # Messages for nicer exceptions, from rfc2616
      def error_message(expected, actual)
        @messages ||= { 
          100 => 'Continue', 
          101 => 'Switching Protocols',
          200 => 'OK',
          201 =>'Created',
          202 => 'Accepted',
          203 => 'Non-Authoritative Information',
          204 => 'No Content',
          205 => 'Reset Content',
          206 => 'Partial Content',
          300 => 'Multiple Choices',
          301 => 'Moved Permanently',
          302 => 'Found',
          303 => 'See Other',
          304 => 'Not Modified',
          305 => 'Use Proxy',
          307 => 'Temporary Redirect',
          400 => 'Bad Request',
          401 => 'Unauthorized',
          402 => 'Payment Required',
          403 => 'Forbidden',
          404 => 'Not Found',
          405 => 'Method Not Allowed',
          406 => 'Not Acceptable',
          407 => 'Proxy Authentication Required',
          408 => 'Request Timeout',
          409 => 'Conflict',
          410 => 'Gone',
          411 => 'Length Required',
          412 => 'Precondition Failed',
          413 => 'Request Entity Too Large',
          414 => 'Request-URI Too Long',
          415 => 'Unsupported Media Type',
          416 => 'Requested Range Not Satisfiable',
          417 => 'Expectation Failed',
          500 => 'Internal Server Error',
          501 => 'Not Implemented',
          502 => 'Bad Gateway',
          503 => 'Service Unavailable',
          504 => 'Gateway Timeout'
        }
        "Expected(#{expected} #{@messages[expected]}) <=> Got(#{actual} #{@messages[actual]})"
      end

      def request(params)
        params[:path] ||= ''
        unless params[:path][0] == '/'
          params[:path] = '/' + params[:path].to_s
        end
        if params[:query] && !params[:query].empty?
          params[:path] << "?#{params[:query]}"
        end
        request = "#{params[:method]} #{params[:path]} HTTP/1.1\r\n"
        params[:headers] ||= {}
        params[:headers]['Host'] = params[:host]
        if params[:body]
          params[:headers]['Content-Length'] = params[:body].length
        end
        for key, value in params[:headers]
          request << "#{key}: #{value}\r\n"
        end
        request << "\r\n#{params[:body]}"
        @connection.write(request)

        response = Fog::Response.new
        response.request = params
        response.status = @connection.readline[9..11].to_i
        while true
          data = @connection.readline.chomp!
          if data == ""
            break
          end
          header = data.split(': ')
          response.headers[capitalize(header[0])] = header[1]
        end

        if params[:parser]
          body = Nokogiri::XML::SAX::PushParser.new(params[:parser])
        else
          body = ''
        end

        unless params[:method] == 'HEAD'
          if response.headers['Content-Length']
            body << @connection.read(response.headers['Content-Length'].to_i)
          elsif response.headers['Transfer-Encoding'] == 'chunked'
            while true
              # 2 == "/r/n".length
              chunk_size = @connection.readline.chomp!.to_i(16) + 2
              chunk = @connection.read(chunk_size)
              body << chunk[0...-2]
              if chunk_size == 2
                break
              end
            end
          end
        end

        if params[:parser]
          body.finish
          response.body = params[:parser].response
        else
          response.body = body
        end

        if params[:expects] && params[:expects] != response.status
          raise(error_message(params[:expects], response.status))
        else
          response
        end
      end

      private

      def capitalize(header)
        words = header.split('-')
        header = ''
        for word in words
          header << word[0..0].upcase << word[1..-1] << '-'
        end
        header.chop!
      end

    end
  end

else

  module Fog
    class Connection

      def initialize(url)
      end

      def request(params)
      end

    end
  end

end
