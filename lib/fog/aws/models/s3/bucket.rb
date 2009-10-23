module Fog
  module AWS
    class S3

      class Bucket < Fog::Model

        identity  :name,          'Name'

        attribute :creation_date, 'CreationDate'
        attribute :owner

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

        def location=(new_location)
          @location = new_location
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

        def save
          options = {}
          if @location
            options['LocationConstraint'] = @location
          end
          connection.put_bucket(@name, options)
          true
        end

      end

    end
  end
end
