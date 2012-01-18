module Fog
  module Vcloud
    class Compute

      class Real
        def get_vm_memory(href, parse = true)
          request(
                  :expects  => 200,
                  :uri      => href,
                  :parse    => parse
                  )
        end
      end
    end
  end
end
