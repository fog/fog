module Fog
  module AWS
    class S3

      def buckets
        Fog::AWS::S3::Buckets.new(:connection => self)
      end

      class Buckets < Fog::Collection

        model Fog::AWS::S3::Bucket

        def all
          data = connection.get_service.body
          buckets = Fog::AWS::S3::Buckets.new(:connection => connection)
          data['Buckets'].each do |bucket|
            buckets << Fog::AWS::S3::Bucket.new({
              :collection => buckets,
              :connection => connection,
              :owner      => {
                :display_name => owner['DisplayName'], 
                :id => owner['ID']
              }
            }.merge!(bucket))
          end
          buckets
        end

        def get(name, options = {})
          remap_attributes(options, {
            :max_keys     => 'max-keys',
          })
          data = connection.get_bucket(name, options).body
          bucket = Fog::AWS::S3::Bucket.new({
            :collection => self,
            :connection => connection,
            :name       => data['Name']
          })
          options = {}
          for key, value in data
            if ['Delimiter', 'IsTruncated', 'Marker', 'MaxKeys', 'Prefix'].include?(key)
              options[key] = value
            end
          end
          bucket.objects.merge_attributes(options)
          data['Contents'].each do |object|
            bucket.objects << Fog::AWS::S3::Object.new({
              :bucket     => bucket,
              :connection => connection,
              :collection => bucket.objects,
              :owner      => {
                :display_name => owner['DisplayName'], 
                :id => owner['ID']
              }
            }.merge!(object))
          end
          bucket
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
