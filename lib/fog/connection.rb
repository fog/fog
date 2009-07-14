require 'rubygems'
require 'openssl'
require 'socket'
require 'uri'

require "#{File.dirname(__FILE__)}/response"

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
            body << @connection.read(chunk_size)
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

      response
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
