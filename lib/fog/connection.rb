require 'rubygems'
require 'openssl'
require 'socket'
require 'uri'

require "fog/errors"
require "fog/response"

unless Fog.mocking?

  module Fog
    class Connection

      unless const_defined?(:CHUNK_SIZE)
        CHUNK_SIZE = 1048576 # 1 megabyte
      end

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
        if params[:body] && !params[:headers]['Content-Length']
          params[:headers]['Content-Length'] = params[:body].length
        end
        for key, value in params[:headers]
          request << "#{key}: #{value}\r\n"
        end
        request << "\r\n"
        @connection.write(request)

        if params[:body]
          if params[:body].is_a?(String)
            body = StringIO.new(params[:body])
          else
            body = params[:body]
          end
          while chunk = body.read(CHUNK_SIZE)
            @connection.write(chunk)
          end
        end

        response = Fog::Response.new
        response.request = params
        response.status = @connection.readline[9..11].to_i
        if params[:expects] && params[:expects] != response.status
          error = true
        end
        while true
          data = @connection.readline.chomp!
          if data == ""
            break
          end
          header = data.split(': ')
          response.headers[capitalize(header[0])] = header[1]
        end

        if error || params[:parser]
          if error
            parser = Fog::Errors::Parser.new
          elsif params[:parser]
            parser = params[:parser]
          end
          body = Nokogiri::XML::SAX::PushParser.new(parser)
        elsif params[:block]
          body = nil
        else
          body = ''
        end

        unless params[:method] == 'HEAD'
          if response.headers['Content-Length']
            if error || !params[:block]
              body << @connection.read(response.headers['Content-Length'].to_i)
            else
              remaining = response.headers['Content-Length'].to_i
              while remaining > 0
                params[:block].call(@connection.read([CHUNK_SIZE, remaining].min))
                remaining -= CHUNK_SIZE;
              end
            end
          elsif response.headers['Transfer-Encoding'] == 'chunked'
            while true
              # 2 == "/r/n".length
              chunk_size = @connection.readline.chomp!.to_i(16) + 2
              chunk = @connection.read(chunk_size)[0...-2]
              if error || !params[:block]
                body << chunk
              else
                params[:block].call(chunk)
              end
              if chunk_size == 2
                break
              end
            end
          end
        end

        if parser
          body.finish
          response.body = parser.response
        else
          response.body = body
        end

        if error
          raise(Fog::Errors.status_error(params[:expects], response.status, response))
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
