require File.dirname(__FILE__) + '/aws/simpledb'
require File.dirname(__FILE__) + '/aws/s3'

require 'rubygems'
require 'eventmachine'
require 'uri'

module Fog
  module AWS
    class Connection < EventMachine::Connection
     include EventMachine::Deferrable

     attr_accessor :headers, :method, :url, :parser, :status

     def response
       @parser.response
     end

     def post_init
       @data = nil
       @headers = {}
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
       headers.merge!({'Host' => host})
       send_data("#{method} #{path} HTTP/1.1\r\n#{headers.collect {|k,v| "#{k}: #{v}\r\n"}.join('')}\r\n")
     end

     def receive_data(data)
       unless @data
         if data =~ /\AHTTP\/1\.[01] ([\d]{3})/
           @status = $1.to_i
         else
           @status = 0
         end
         @data = data.split(/<\?xml.*\?>/)[1]
         Nokogiri::XML::SAX::Parser.new(@parser).parse(@data)
         set_deferred_status(:succeeded, self)
         EventMachine.stop_event_loop
       end
     end

    end
  end
end