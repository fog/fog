module Fog
  module Compute
    class Brightbox
      class Real

        def update_server(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          request("put", "/1.0/servers/#{identifier}", [200], options)
        end

      end
    end
  end
end