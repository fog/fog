module Fog
  module DNS
    class Dreamhost
      class Mock
        def create_record(record, type, value, comment = "")
          Fog::Mock.not_implemented
        end
      end

      class Real
        def create_record(record, type, value, comment = "")
          request( :expects  => 200,
                   :method   => 'GET',
                   :path     => "/",
                   :query    => {
                     :record    => record,
                     :type      => type,
                     :value     => value,
                     :cmd       => 'dns-add_record',
                     :comment   => comment
                   }
                 )
        end
      end
    end
  end
end
