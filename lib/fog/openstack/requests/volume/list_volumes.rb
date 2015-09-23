module Fog
  module Volume
    class OpenStack
      class Real
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

      class Mock
        def list_volumes(options = true, options_deprecated = {})
          response = Excon::Response.new
          response.status = 200
          self.data[:volumes] ||= [
            { "status" => "available",
              "description" => "test 1 desc",
              "availability_zone" => "nova",
              "name" => "Volume1",
              "attachments" => [{}],
              "volume_type" => nil,
              "snapshot_id" => nil,
              "size" => 1,
              "id" => 1,
              "created_at" => Time.now,
              "metadata" => {} },
            { "status" => "available",
              "description" => "test 2 desc",
              "availability_zone" => "nova",
              "name" => "Volume2",
              "attachments" => [{}],
              "volume_type" => nil,
              "snapshot_id" => nil,
              "size" => 1,
              "id" => 2,
              "created_at" => Time.now,
              "metadata" => {} }
            ]
          response.body = { 'volumes' => self.data[:volumes] }
          response
        end
      end
    end
  end
end
