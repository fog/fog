module Fog
  module AWS
    class S3

      class Bucket < Fog::Model

        attr_accessor :creation_date,
                      :location,
                      :name,
                      :owner

        def initialize(attributes = {})
          remap_attributes(attributes, {
            'CreationDate'  => :creation_date,
            'Name'          => :name
          })
          super
        end

        def delete
          connection.delete_bucket(name)
          true
        end

        def location
          data = s3.get_bucket_location(name)
          data.body['LocationConstraint']
        end

        def objects
          Fog::AWS::S3::Objects.new(
            :bucket       => self,
            :connection   => connection
          )
        end

        def payer
          data = connection.get_request_payment(name)
          data.body['Payer']
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
          true
        end

        private

        def buckets
          @buckets
        end

        def buckets=(new_buckets)
          @buckets = new_buckets
        end

      end

    end
  end
end
