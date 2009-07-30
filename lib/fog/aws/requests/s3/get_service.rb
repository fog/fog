module Fog
  module AWS
    class S3

      # List information about S3 buckets for authorized user
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'Buckets'<~Hash>:
      #       * 'Name'<~String> - Name of bucket
      #       * 'CreationTime'<~Time> - Timestamp of bucket creation
      #     * 'Owner'<~Hash>:
      #       * 'DisplayName'<~String> - Display name of bucket owner
      #       * 'ID'<~String> - Id of bucket owner
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
