module Fog
  module Compute
    class XenServer
      class Real
        def destroy_record(ref, provider_class)
          @connection.request({ :parser => Fog::Parsers::XenServer::Base.new, :method => "#{provider_class}.destroy" }, ref)
        end
      end
    end
  end
end