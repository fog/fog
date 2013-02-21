module Fog
  module Compute
    class Joyent
     class Real
      def resize_machine(id, flavor)
        request(
          :method => "POST",
          :path => "/my/machines/#{id}",
          :query => {"action" => "resize", "package" => flavor.name}
        )
      end
     end
    end
  end
end
