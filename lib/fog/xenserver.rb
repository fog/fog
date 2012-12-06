module Fog
  module XenServer 

    class InvalidLogin < Fog::Errors::Error; end
    class NotFound < Fog::Errors::Error; end
    class RequestFailed < Fog::Errors::Error; end

    extend Fog::Provider
    
    service(:compute, 'xenserver/compute', 'Compute')  
    
    class Connection
      require 'xmlrpc/client'
    
      def initialize(host)
        @factory = XMLRPC::Client.new(host, '/')
        @factory.set_parser(XMLRPC::XMLParser::REXMLStreamParser.new)
      end
    
      def authenticate( username, password )
        response = @factory.call('session.login_with_password', username.to_s, password.to_s)
        raise Fog::XenServer::InvalidLogin.new unless response["Status"] =~ /Success/
        @credentials = response["Value"]
      end
    
      def request(options, *params)
        begin
          parser   = options.delete(:parser)
          method   = options.delete(:method)
          
          if params.empty?
            response = @factory.call(method, @credentials)
          else
            if params.length.eql?(1) and params.first.is_a?(Hash)
              response = @factory.call(method, @credentials, params.first)
            elsif params.length.eql?(2) and params.last.is_a?(Array)
              response = @factory.call(method, @credentials, params.first, params.last)
            else
              response = eval("@factory.call('#{method}', '#{@credentials}', #{params.map {|p|  p.is_a?(String) ? "'#{p}'" : p}.join(',')})")
            end
          end
          raise RequestFailed.new("#{method}: " + response["ErrorDescription"].to_s) unless response["Status"].eql? "Success"
          if parser
            parser.parse( response["Value"] )
            response = parser.response
          end
          
          response
        end
      end
    end

  end
end


