require 'fog/core/collection'
require 'fog/aws/models/storage/version'

module Fog
  module Storage
    class AWS

      class Versions < Fog::Collection

        attribute :file

        model Fog::Storage::AWS::Version

        def all
          data = connection.get_bucket_object_versions(file.directory.key, :prefix => file.key).body['Versions']
          load(data)
        end

        def new(attributes = {})
          requires :file

          version_type = attributes.keys.first

          model = super({ :file => file }.merge!(attributes[version_type]))
          model.delete_marker = version_type == 'DeleteMarker'

          model
        end

      end

    end
  end
end