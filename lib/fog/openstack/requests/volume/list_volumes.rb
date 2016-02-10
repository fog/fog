module Fog
  module Volume
    class OpenStack
      module Real
        def list_volumes(options = true, options_deprecated = {})
          if options.is_a?(Hash)
            path  = 'volumes'
            query = options
          else
            # Backwards compatibility layer, when 'detailed' boolean was sent as first param
            if options
              Fog::Logger.deprecation('Calling OpenStack[:volume].list_volumes(true) is deprecated, use .list_volumes_detailed instead')
            else
              Fog::Logger.deprecation('Calling OpenStack[:volume].list_volumes(false) is deprecated, use .list_volumes({}) instead')
            end
            path  = options ? 'volumes/detail' : 'volumes'
            query = options_deprecated
          end

          request(
            :expects => 200,
            :method  => 'GET',
            :path    => path,
            :query   => query
          )
        end
      end
    end
  end
end
