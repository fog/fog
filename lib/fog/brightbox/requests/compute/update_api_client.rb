module Fog
  module Compute
    class Brightbox
      class Real

        def update_api_client(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          request("put", "/1.0/api_clients/#{identifier}", [200], options)
        end

      end
    end
  end
end