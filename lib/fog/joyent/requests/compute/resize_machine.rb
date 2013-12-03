module Fog
  module Compute
    class Joyent
     class Real
      def resize_machine(id, package)
        request(
          :method => "POST",
          :path => "/my/machines/#{id}",
          :query => {"action" => "resize", "package" => package},
          :expects => [202]
        )
      end
     end
    end
  end
end
