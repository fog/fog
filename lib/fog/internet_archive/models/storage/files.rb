require 'fog/core/collection'
require 'fog/internet_archive/models/storage/file'

module Fog
  module Storage
    class InternetArchive

      class Files < Fog::Collection
        extend Fog::Deprecation
        deprecate :get_url, :get_https_url

        attribute :common_prefixes, :aliases => 'CommonPrefixes'
        attribute :delimiter,       :aliases => 'Delimiter'
        attribute :directory
        attribute :is_truncated,    :aliases => 'IsTruncated'
        attribute :marker,          :aliases => 'Marker'
        attribute :max_keys,        :aliases => ['MaxKeys', 'max-keys']
        attribute :prefix,          :aliases => 'Prefix'

        model Fog::Storage::InternetArchive::File

        def all(options = {})
          requires :directory
          options = {
            'delimiter'   => delimiter,
            'marker'      => marker,
            'max-keys'    => max_keys,
            'prefix'      => prefix
          }.merge!(options)
          options = options.reject {|key,value| value.nil? || value.to_s.empty?}
          merge_attributes(options)
          parent = directory.collection.get(
            directory.key,
            options
          )
          if parent
            merge_attributes(parent.files.attributes)
            load(parent.files.map {|file| file.attributes})
          else
            nil
          end
        end

        alias :each_file_this_page :each
        def each
          if !block_given?
            self
          else
            subset = dup.all

            subset.each_file_this_page {|f| yield f}
            while subset.is_truncated
              subset = subset.all(:marker => subset.last.key)
              subset.each_file_this_page {|f| yield f}
            end

            self
          end
        end

        def get(key, options = {}, &block)
          requires :directory
          data = service.get_object(directory.key, key, options, &block)
          normalize_headers(data)
          file_data = data.headers.merge({
            :body => data.body,
            :key  => key
          })
          new(file_data)
        rescue Excon::Errors::NotFound => error
          case error.message
          when /<Code>NoSuchKey<\/Code>/
            nil
          when /<Code>NoSuchBucket<\/Code>/
            raise(Fog::Storage::InternetArchive::NotFound.new("Directory #{directory.identity} does not exist."))
          else
            raise(error)
          end
        end

        def get_url(key, expires, options = {})
          requires :directory
          service.get_object_url(directory.key, key, expires, options)
        end

        def get_http_url(key, expires, options = {})
          requires :directory
          service.get_object_http_url(directory.key, key, expires, options)
        end

        def get_https_url(key, expires, options = {})
          requires :directory
          service.get_object_https_url(directory.key, key, expires, options)
        end

        def head(key, options = {})
          requires :directory
          data = service.head_object(directory.key, key, options)
          normalize_headers(data)
          file_data = data.headers.merge({
            :key => key
          })
          new(file_data)
        rescue Excon::Errors::NotFound
          nil
        end

        def new(attributes = {})
          requires :directory
          super({ :directory => directory }.merge!(attributes))
        end

        def normalize_headers(data)
          data.headers['Last-Modified'] = Time.parse(data.get_header('Last-Modified'))
          data.headers['ETag'] = data.get_header('ETag').gsub('"','')
        end

      end

    end
  end
end
