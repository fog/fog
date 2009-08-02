module Fog
  module AWS
    class S3

      def buckets
        Fog::AWS::S3::Buckets.new(:connection => self)
      end

      class Buckets < Fog::Collection

        def all
          data = connection.get_service.body
          owner = Fog::AWS::S3::Owner.new({
            :connection   => connection,
            :display_name => data['Owner']['DisplayName'],
            :id           => data['Owner']['ID']
          })
          buckets = []
          data['Buckets'].each do |bucket|
            buckets << Fog::AWS::S3::Bucket.new({
              :connection     => connection,
              :creation_date  => bucket['CreationDate'],
              :name           => bucket['Name'],
              :owner          => owner
            })
          end
          buckets
        end

        def get(name, options = {})
          data = connection.get_bucket(name, options).body
          objects = Fog::AWS::S3::Objects.new({
            :connection   => connection,
            :is_truncated => data['IsTruncated'],
            :marker       => data['Marker'],
            :max_keys     => data['MaxKeys'],
            :name         => data['Name'],
            :prefix       => data['Prefix']
          })
          data['Contents'].each do |object|
            objects << Fog::AWS::S3::Object.new({
              :connection     => connection,
              :etag           => object['ETag'],
              :key            => object['Key'],
              :last_modified  => object['LastModified'],
              :owner          => Fog::AWS::S3::Owner.new({
                :display_name => object['Owner']['DisplayName'],
                :id           => object['Owner']['ID']
              }),
              :size           => object['Size'],
              :storage_class  => object['StorageClass']
            })
          end
          objects
        end

      end

    end
  end
end
