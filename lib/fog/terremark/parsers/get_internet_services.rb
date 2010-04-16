module Fog
  module Parsers
    module Terremark
      
      class GetInternetServices < Fog::Parsers::Base
        
        def reset
          @in_public_ip_address = false
          @in_internet_service = false
          @response = { 'InternetServices' => [] } #an array of internet services
        end
        
        
        def start_element(name, attributes)
          @value = ''
          case name
            when 'InternetService' #start of a new InternetService:
            @in_internet_service = true 
            when 'PublicIPAddress' #start of new IP Address
            @in_public_ip_address = true
          end
        end
        
        def end_element(name)
          case name
            when 'PublicIPAddress'
            @in_public_ip_address = false
            when 'InternetService'
            @in_internet_service = false
            when 'Id', 'Name'
            if @in_public_ip_address
              @response['InternetServices'].last['PublicIPAddress'][name] = @value
            elsif @in_internet_service
              @response['InternetServices'].last[name] = @value
            
          end
        end
      end
      
      
      
      
    end #end class
  end #end Terremark 
end #end Parsers
end #end Fog
