module Fog
  module Parsers
    module XenServer
      class GetRecords < Fog::Parsers::XenServer::Base
        def reset
          @response = []
        end

        def parse( data )
          parser = Fog::Parsers::XenServer::Base.new
          data.each_pair {|reference, hash| @response << parser.parse( hash ).merge(:reference => reference) }
        end
      end
    end
  end
end
