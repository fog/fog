module Fog
  module Parsers
    module XenServer
      class GetVIFs < Fog::Parsers::XenServer::Base
        
        def reset
          @response = []
        end
        
        def parse( data )
          parser = Fog::Parsers::XenServer::Base.new
          data.each_pair {|reference, vif_hash| @response << parser.parse( vif_hash ).merge(:reference => reference) }
        end
        
      end
      
    end
  end
end
