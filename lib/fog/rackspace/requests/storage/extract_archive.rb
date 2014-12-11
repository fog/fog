module Fog
  module Storage
    class Rackspace
      class Real
        # Extract Archive
        #
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Extract_Archive-d1e2338.html
        #
        # ==== Parameters
        # * container<~String>      - Name for container, should be < 256 bytes and must not contain '/'
        # * data<~String|File>      - file to upload
        # * archive_format<~String> - "tar", "tar.gz", or "tar.bz2"

        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def extract_archive(container, data, archive_format)
          data = Fog::Storage.parse_data(data)
          headers = data[:headers]
          headers["Content-Type"] = ""
          params = { :body => data[:body], :query => {"extract-archive" => archive_format} }

          params.merge!(
            :expects    => 200,
            :idempotent => true,
            :headers    => headers,
            :method     => 'PUT',
            :path       => "#{Fog::Rackspace.escape(container.to_s)}"
          )

          request(params)
        end
      end
    end
  end
end
