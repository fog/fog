module Fog
  module Storage
    class AWS
      class Real

        # Sync clock against S3 to avoid skew errors
        #
        def sync_clock
          response = begin
            get_service
          rescue => error
            error.response
          end
          Fog::Time.now = Time.parse(response.headers['Date'])
        end

      end # Real

      class Mock # :nodoc:all

        def sync_clock
          true
        end

      end # Mock
    end # Storage
  end # AWS
end # Fog