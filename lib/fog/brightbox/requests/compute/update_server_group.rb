module Fog
  module Compute
    class Brightbox
      class Real

        def update_server_group(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          request("put", "/1.0/server_groups/#{identifier}", [202], options)
        end

      end
    end
  end
end