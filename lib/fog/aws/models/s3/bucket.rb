module Fog
  module AWS
    class S3

      class Bucket < Fog::Model

        attribute :creation_date, 'CreationDate'
        attribute :location
        attribute :name,          'Name'
        attribute :owner

        def initialize(attributes = {})
          super
        end

        def buckets
          @buckets
        end

        def destroy
          connection.delete_bucket(name)
          buckets.delete(name)
          true
        end

        def location
          @location ||= begin
            data = s3.get_bucket_location(name)
            data.body['LocationConstraint']
          end
        end

        def objects
          Fog::AWS::S3::Objects.new(
            :bucket       => self,
            :connection   => connection
          )
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

        def new_record?
          buckets.key?(name)
        end

        def reload
          buckets.get(name)
        end

        def save
          options = {}
          if @location
            options['LocationConstraint'] = @location
          end
          connection.put_bucket(name, options)
          buckets[name] = self
          true
        end

        private

        def buckets=(new_buckets)
          @buckets = new_buckets
        end

      end

    end
  end
end
