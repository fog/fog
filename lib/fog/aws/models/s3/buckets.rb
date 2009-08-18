module Fog
  module AWS
    class S3

      def buckets
        Fog::AWS::S3::Buckets.new(:connection => self)
      end

      class Buckets < Fog::Collection

        def all
          data = connection.get_service.body
          owner = Fog::AWS::S3::Owner.new(data.delete('Owner').merge!(:connection => connection))
          buckets = Fog::AWS::S3::Buckets.new
          data['Buckets'].each do |bucket|
            buckets << Fog::AWS::S3::Bucket.new({
              :connection     => connection,
              :owner          => owner
            }.merge!(bucket))
          end
          buckets
        end

        def create(attributes = {})
          bucket = new(attributes)
          bucket.save
          bucket
        end

        def new(attributes = {})
          Fog::AWS::S3::Bucket.new(attributes.merge!(:connection => connection))
        end

      end

    end
  end
end
