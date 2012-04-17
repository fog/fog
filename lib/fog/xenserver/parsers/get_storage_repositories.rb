module Fog
  module Parsers
    module XenServer
      class GetStorageRepositories < Fog::Parsers::XenServer::Base
        
        def reset
          @response = []
        end
        
        def parse( data )
          parser = Fog::Parsers::XenServer::Base.new
          data.each_pair {|reference, sr_hash| @response << parser.parse( sr_hash ).merge(:reference => reference) }
        end
        
      end
      
    end
  end
end
