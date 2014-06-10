module Fog
  module Parsers
    module XenServer
      class GetNetworks < Fog::Parsers::XenServer::Base
        def reset
          @response = []
        end

        def parse( data )
          parser = Fog::Parsers::XenServer::Base.new
          data.each_pair {|reference, network_hash| @response << parser.parse( network_hash ).merge(:reference => reference) }
        end
      end
    end
  end
end
