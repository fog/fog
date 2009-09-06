module Fog
  module AWS
    class S3

      class Bucket < Fog::Model

        attribute :creation_date, 'CreationDate'
        attribute :location
        attribute :name,          'Name'
        attribute :owner

        def buckets
          @buckets
        end

        def destroy
          connection.delete_bucket(@name)
          true
        rescue Fog::Errors::NotFound
          false
        end

        def location
          data = connection.get_bucket_location(@name)
          data.body['LocationConstraint']
        end

        def objects
          @objects ||= begin
            Fog::AWS::S3::Objects.new(
              :bucket       => self,
              :connection   => connection
            )
          end
        end

        def payer
          data = connection.get_request_payment(@name)
          data.body['Payer']
        end

        def payer=(new_payer)
          connection.put_request_payment(@name, new_payer)
          @payer = new_payer
        end

        def reload
          new_attributes = buckets.get(@name).attributes
          merge_attributes(new_attributes)
        end

        def save
          options = {}
          if @location
            options['LocationConstraint'] = @location
          end
          connection.put_bucket(@name, options)
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
