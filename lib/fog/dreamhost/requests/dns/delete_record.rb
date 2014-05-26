module Fog
  module DNS
    class Dreamhost
      class Mock
        def delete_record(name, type, value)
          raise Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_record(name, type, value)
          request( :expects  => 200,
                   :method   => "GET",
                   :path     => "/",
                   :query    => {
                     :cmd      => 'dns-remove_record',
                     :type     => type,
                     :record   => name,
                     :value    => value,
                   }
                 )
        end
      end
    end
  end
end
