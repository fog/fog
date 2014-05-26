module Fog
  module Compute
    class XenServer
      class Real
        require 'fog/xenserver/parser'

        def get_record( ref, klass, options = {} )
          get_record_by_ref ref, klass, options
        end

        def get_record_by_ref( ref, klass, options = {} )
          @connection.request({:parser => Fog::Parsers::XenServer::Base.new, :method => "#{klass}.get_record"}, ref).merge(:reference => ref)
        end
      end

      class Mock
        def get_record_by_ref
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
