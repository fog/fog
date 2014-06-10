module Fog
  module Vcloud
    class Compute
      class Real
        def get_vm_disks(href)
          request(
                  :expects  => 200,
                  :uri      => href,
                  :parse    => true#false#true
                  )
        end
      end
    end
  end
end
