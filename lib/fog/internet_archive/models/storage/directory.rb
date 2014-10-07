require 'fog/core/model'
require 'fog/internet_archive/models/storage/files'
require 'fog/internet_archive/models/storage/ia_attributes.rb'

module Fog
  module Storage
    class InternetArchive
      class Directory < Fog::Model
        extend Fog::Storage::IAAttributes::ClassMethods
        include Fog::Storage::IAAttributes::InstanceMethods

        identity  :key,           :aliases => ['Name', 'name']

        attribute :creation_date, :aliases => 'CreationDate'

        # treat these differently
        attribute :collections
        attribute :subjects

        ia_metadata_attribute :ignore_preexisting_bucket
        ia_metadata_attribute :interactive_priority

        # acl for internet archive is always public-read
        def acl
          'public-read'
        end

        def acl=(new_acl)
          'public-read'
        end

        # See http://archive.org/help/abouts3.txt
        def destroy
          Fog::Logger.warning("fog: Internet Archive does not support deleting a Bucket (i.e. Item).  For details see: See http://archive.org/help/abouts3.txt")
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

        def public=(new_public)
          'public-read'
        end

        def public_url
          requires :key
          "http://#{Fog::InternetArchive::DOMAIN_NAME}/details/#{key}"
        end

        def save
          requires :key

          options = {}

          options['x-archive-ignore-preexisting-bucket'] = ignore_preexisting_bucket if ignore_preexisting_bucket
          options['x-archive-interactive-priority'] = interactive_priority if interactive_priority

          set_metadata_array_headers(:collections, options)
          set_metadata_array_headers(:subjects, options)

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
