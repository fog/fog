module Fog
  module AWS
    class S3

      # List information about S3 buckets for authorized user
      #
      # ==== Parameters
      # FIXME: docs
      def get_service
        request({
          :expects => 200,
          :headers => {},
          :host => @host,
          :method => 'GET',
          :parser => Fog::Parsers::AWS::S3::GetService.new,
          :url => @host
        })
      end

    end
  end
end
