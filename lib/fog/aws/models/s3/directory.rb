require 'fog/model'
require 'fog/aws/models/s3/files'

module Fog
  module AWS
    module S3

      class Directory < Fog::Model
        extend Fog::Deprecation
        deprecate(:name, :key)
        deprecate(:name=, :key=)

        identity  :key,           ['Name', 'name']

        attribute :creation_date, 'CreationDate'

        def destroy
          requires :key
          connection.delete_bucket(key)
          true
        rescue Excon::Errors::NotFound
          false
        end

        def location
          requires :key
          data = connection.get_bucket_location(key)
          data.body['LocationConstraint']
        end

        def location=(new_location)
          @location = new_location
        end

        def files
          @files ||= begin
            Fog::AWS::S3::Files.new(
              :directory    => self,
              :connection   => connection
            )
          end
        end

        def payer
          requires :key
          data = connection.get_request_payment(key)
          data.body['Payer']
        end

        def payer=(new_payer)
          requires :key
          connection.put_request_payment(key, new_payer)
          @payer = new_payer
        end

        def save
          requires :key
          options = {}
          if @location
            options['LocationConstraint'] = @location
          end
          connection.put_bucket(key, options)
          true
        end

      end

    end
  end
end
