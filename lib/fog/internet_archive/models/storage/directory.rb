require 'fog/core/model'
require 'fog/internet_archive/models/storage/files'
require 'fog/internet_archive/models/storage/versions'

module Fog
  module Storage
    class InternetArchive

      class Directory < Fog::Model
        VALID_ACLS = ['private', 'public-read', 'public-read-write', 'authenticated-read']

        # See http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketPUT.html
        INVALID_LOCATIONS = ['us-east-1']

        attr_reader :acl

        identity  :key,           :aliases => ['Name', 'name']

        attribute :creation_date, :aliases => 'CreationDate'

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
          requires :key
          attributes[:location] || bucket_location || self.service.region
        end

        def location=(new_location)
          if INVALID_LOCATIONS.include?(new_location)
            raise ArgumentError, "location must not include any of #{INVALID_LOCATIONS.join(', ')}. See http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketPUT.html"
          else
            merge_attributes(:location => new_location)
          end
        end

        def files
          @files ||= Fog::Storage::InternetArchive::Files.new(:directory => self, :service => service)
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
          @versions ||= Fog::Storage::InternetArchive::Versions.new(:directory => self, :service => service)
        end

        def public=(new_public)
          self.acl = new_public ? 'public-read' : 'private'
          new_public
        end

        def public_url
          requires :key
          if service.get_bucket_acl(key).body['AccessControlList'].detect {|grant| grant['Grantee']['URI'] == 'http://acs.amazonaws.com/groups/global/AllUsers' && grant['Permission'] == 'READ'}
            if key.to_s =~ Fog::InternetArchive::COMPLIANT_BUCKET_NAMES
              "https://#{key}.s3.#{Fog::InternetArchive::DOMAIN_NAME}"
            else
              "https://s3.#{Fog::InternetArchive::DOMAIN_NAME}/#{key}"
            end
          else
            nil
          end
        end

        def save
          requires :key

          options = {}

          options['x-amz-acl'] = acl if acl

          if location = attributes[:location] || (self.service.region != 'us-east-1' && self.service.region)
            options['LocationConstraint'] = location
          end

          service.put_bucket(key, options)

          true
        end

        private

        def bucket_location
          data = service.get_bucket_location(key)
          data.body['LocationConstraint']
        end

      end

    end
  end
end
