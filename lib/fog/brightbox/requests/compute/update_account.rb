module Fog
  module Compute
    class Brightbox
      class Real

        def update_account(options)
          return nil if options.empty? || options.nil?
          request("put", "/1.0/account", [200], options)
        end

      end
    end
  end
end