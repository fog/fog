require 'fog/core/model'
require 'fog/aws/models/storage/files'

module Fog
  module AWS
    class Storage

      class Directory < Fog::Model
        extend Fog::Deprecation
        deprecate(:name, :key)
        deprecate(:name=, :key=)

        identity  :key,           :aliases => ['Name', 'name']

        attribute :creation_date, :aliases => 'CreationDate'

        def acl=(new_acl)
          valid_acls = ['private', 'public-read', 'public-read-write', 'authenticated-read']
          unless valid_acls.include?(new_acl)
            raise ArgumentError.new("acl must be one of [#{valid_acls.join(', ')}]")
          end
          @acl = new_acl
        end

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
            Fog::AWS::Storage::Files.new(
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
          if @acl
            options['x-amz-acl'] = @acl
          end
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
