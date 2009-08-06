module Fog
  module AWS
    class S3

      class Bucket < Fog::Model

        attr_accessor :creation_date, :location, :name, :owner

        def initialize(attributes = {})
          remap_attributes(attributes, {
            'CreationDate'  => :creation_date,
            'Name'          => :name
          })
          super
          @objects ||= []
        end

        def delete
          return false if new_record?
          connection.delete_bucket(name)
          @new_record = true
          true
        end

        def location
          @location ||= begin
            data = s3.get_bucket_location(name)
            data.body['LocationConstraint']
          end
        end

        def objects
          data = connection.get_bucket(name, options).body
          objects_data = {}
          for key, value in data
            if ['IsTruncated', 'Marker', 'MaxKeys', 'Prefix'].include?(key)
              objects_data[key] = value
            end
          end
          objects = Fog::AWS::S3::Objects.new({
            :bucket       => bucket,
            :connection   => connection
          }.merge!(objects_data))
          data['Contents'].each do |object|
            owner = Fog::AWS::S3::Owner.new(object.delete('Owner').merge!(:connection => connection))
            bucket.objects << Fog::AWS::S3::Object.new({
              :bucket         => bucket,
              :connection     => connection,
              :owner          => owner
            }.merge!(object))
          end
          objects
        end

        def payer
          @payer ||= begin
            data = connection.get_request_payment(name)
            data.body['Payer']
          end
        end

        def payer=(new_payer)
          connection.put_request_payment(name, new_payer)
          @payer = new_payer
        end

        def save
          options = {}
          if @location
            options['LocationConstraint'] = @location
          end
          connection.put_bucket(name, options)
          @new_record = false
          true
        end

      end

    end
  end
end
