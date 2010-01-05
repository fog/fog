module Fog
  module AWS
    class S3

      def buckets
        Fog::AWS::S3::Buckets.new(:connection => self)
      end

      class Buckets < Fog::Collection

        model Fog::AWS::S3::Bucket

        def all
          if @loaded
            clear
          end
          @loaded = true
          data = connection.get_service.body
          data['Buckets'].each do |bucket|
            self << new(bucket)
          end
          self
        end

        def get(name, options = {})
          remap_attributes(options, {
            :max_keys     => 'max-keys',
          })
          data = connection.get_bucket(name, options).body
          bucket = new(:name => data['Name'])
          options = {}
          for key, value in data
            if ['Delimiter', 'IsTruncated', 'Marker', 'MaxKeys', 'Prefix'].include?(key)
              options[key] = value
            end
          end
          bucket.objects.merge_attributes(options)
          bucket.objects.instance_variable_set(:@loaded, true)
          data['Contents'].each do |object|
            bucket.objects << bucket.objects.new(object)
          end
          bucket
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
