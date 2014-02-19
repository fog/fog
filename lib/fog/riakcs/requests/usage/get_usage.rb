module Fog
  module RiakCS
    class Usage
      module Utils
        TYPES_TO_STRING = { :access  => 'a', :storage => 'b' }
        DEFAULT_TYPES   = TYPES_TO_STRING.keys
        DEFAULT_FORMAT  = :json

        def sanitize_and_convert_time(time)
          time.utc.iso8601.gsub(/[:-]/, '')
        end

        def format_and_types_to_path(format, types)
          format_character = format.to_s.split('').first
          type_characters  = types.map { |t| TYPES_TO_STRING[t] }.compact

          [type_characters, format_character].flatten.compact.join
        end

        def request_uri(access_key_id, options)
          format        = DEFAULT_FORMAT
          types         = options[:types]       || DEFAULT_TYPES
          start_time    = options[:start_time]  || Time.now.utc - 86400
          end_time      = options[:end_time]    || Time.now.utc

          [access_key_id,
           format_and_types_to_path(format, types),
           sanitize_and_convert_time(start_time),
           sanitize_and_convert_time(end_time)].join('.')
        end
      end

      class Real
        include Utils

        def get_usage(access_key_id, options = {})
          response = @connection.get_object('riak-cs', ["usage", request_uri(access_key_id, options)].join("/"))

          if !response.body.empty?
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end
      end

      class Mock
        include Utils

        def get_usage(access_key, options = {})
          Excon::Response.new.tap do |response|
            response.status = 200
            response.headers['Content-Type'] = 'application/json'
            response.body = {
              'Access' => {
                'Nodes'   => [],
                'Errors'  => []
              },
              'Storage' => {
                'Samples' => [],
                'Errors'  => []
              }
            }
          end
        end
      end
    end
  end
end
