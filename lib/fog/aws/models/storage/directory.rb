require 'fog/core/model'
require 'fog/aws/models/storage/files'
require 'fog/aws/models/storage/versions'

module Fog
  module Storage
    class AWS

      class Directory < Fog::Model
        VALID_ACLS = ['private', 'public-read', 'public-read-write', 'authenticated-read']

        attr_reader :acl

        identity  :key,           :aliases => ['Name', 'name']

        attribute :creation_date, :aliases => 'CreationDate', :type => 'time'
        attribute :location,      :aliases => 'LocationConstraint', :type => 'string'

        def acl=(new_acl)
          unless VALID_ACLS.include?(new_acl)
            raise ArgumentError.new("acl must be one of [#{VALID_ACLS.join(', ')}]")
          else
            @acl = new_acl
          end
        end

        def destroy
          requires :key
          service.delete_bucket(key)
          true
        rescue Excon::Errors::NotFound
          false
        end

        def location
          @location ||= (bucket_location || self.service.region)
        end

        # NOTE: you can't change the region once the bucket is created
        def location=(new_location)
          @location = new_location
        end

        def files
          @files ||= Fog::Storage::AWS::Files.new(:directory => self, :service => service)
        end

        def payer
          requires :key
          data = service.get_request_payment(key)
          data.body['Payer']
        end

        def payer=(new_payer)
          requires :key
          service.put_request_payment(key, new_payer)
          @payer = new_payer
        end

        def versioning?
          requires :key
          data = service.get_bucket_versioning(key)
          data.body['VersioningConfiguration']['Status'] == 'Enabled'
        end

        def versioning=(new_versioning)
          requires :key
          service.put_bucket_versioning(key, new_versioning ? 'Enabled' : 'Suspended')
        end

        def versions
          @versions ||= Fog::Storage::AWS::Versions.new(:directory => self, :service => service)
        end

        def public=(new_public)
          self.acl = new_public ? 'public-read' : 'private'
          new_public
        end

        def public_url
          requires :key
          if service.get_bucket_acl(key).body['AccessControlList'].detect {|grant| grant['Grantee']['URI'] == 'http://acs.amazonaws.com/groups/global/AllUsers' && grant['Permission'] == 'READ'}
            service.request_url(
              :bucket_name => key
            )
          else
            nil
          end
        end

        def save
          requires :key

          options = {}

          options['x-amz-acl'] = acl if acl

          # http://docs.aws.amazon.com/AmazonS3/latest/API/RESTBucketPUT.html
          # Ignore the default region us-east-1
          if !persisted? && location != DEFAULT_REGION
            options['LocationConstraint'] = location
          end

          service.put_bucket(key, options)
          attributes[:is_persisted] = true

          true
        end

        def persisted?
          # is_persisted is true in case of directories.get or after #save
          # creation_date is set in case of directories.all
          attributes[:is_persisted] || !!attributes[:creation_date]
        end

        private

        def bucket_location
          requires :key
          return nil unless persisted?
          data = service.get_bucket_location(key)
          data.body['LocationConstraint']
        end

      end

    end
  end
end
