module Fog
  module DNS
    class Dreamhost
      class Mock
        def request(*args)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_records
          request( :expects  => 200,
                   :method   => "GET",
                   :path     => "/",
                   :query    => { :cmd => 'dns-list_records' } )
        end
      end
    end
  end
end
