module Fog
  module AWS
    class S3

      class Bucket < Fog::Model

        attr_accessor :creation_date, :location, :name, :owner

        def delete
          connection.delete_bucket(name)
          true
        end

        def location
          data = s3.get_bucket_location(name)
          @location = data.body['LocationConstraint']
        end

        def payer
          data = connection.get_request_payment(name)
          data.body['Payer']
        end

        def payer=(new_payer)
          connection.put_request_payment(name, new_payer)
          new_payer
        end

        def save
          options = {}
          if @location
            options['LocationConstraint'] = @location
          end
          connection.put_bucket(name, options)
          true
        end

      end

    end
  end
end
