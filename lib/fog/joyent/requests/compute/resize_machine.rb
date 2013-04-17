module Fog
  module Compute
    class Joyent
     class Real
      def resize_machine(id, package)
        request(
          :method => "POST",
          :path => "/my/machines/#{id}",
          :query => {"action" => "resize", "package" => package}
        )
      end
     end
    end
  end
end
