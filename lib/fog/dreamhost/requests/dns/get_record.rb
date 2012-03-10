module Fog
  module DNS
    class Dreamhost
      class Real
        
        def get_record(record_name)
          data = request( :expects  => 200,
                          :method   => "GET",
                          :path     => "/",
                          :query    => { :cmd => 'dns-list_records' } )
        end

      end
    end
  end
end
