module Fog
  module XenServer 
    extend Fog::Provider
    
    service(:compute, 'xenserver/compute', 'Compute')  
    
    class Connection
      require 'xmlrpc/client'
    
      def initialize(host)
        @factory = XMLRPC::Client.new(host, '/')
        @factory.set_parser(XMLRPC::XMLParser::REXMLStreamParser.new)
      end
    
      def authenticate( username, password )
        begin
          response = @factory.call('session.login_with_password', username, password )
          raise Fog::XenServer::InvalidLogin unless response["Status"] =~ /Success/
        end
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
            else
              response = eval("@factory.call('#{method}', '#{@credentials}', #{params.map {|p|  p.is_a?(String) ? "'#{p}'" : p}.join(',')})")
            end
          end
          #puts "RESPONSE: #{response}"
                    
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


