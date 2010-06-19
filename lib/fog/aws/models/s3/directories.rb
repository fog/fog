require 'fog/collection'
require 'fog/aws/models/s3/directory'

module Fog
  module AWS
    module S3

      module Collections
        def directories
          Fog::AWS::S3::Directories.new(:connection => self)
        end
      end

      class Directories < Fog::Collection

        model Fog::AWS::S3::Directory

        def all
          data = connection.get_service.body['Buckets']
          load(data)
        end

        def get(key, options = {})
          remap_attributes(options, {
            :delimiter  => 'delimiter',
            :marker     => 'marker',
            :max_keys   => 'max-keys',
            :prefix     => 'prefix'
          })
          data = connection.get_bucket(key, options).body
          directory = new(:key => data['Name'])
          options = {}
          for k, v in data
            if ['Delimiter', 'IsTruncated', 'Marker', 'MaxKeys', 'Prefix'].include?(k)
              options[k] = v
            end
          end
          directory.files.merge_attributes(options)
          directory.files.load(data['Contents'])
          directory
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
