require 'fog/core/model'
require 'fog/google/models/storage/files'

module Fog
  module Storage
    class Google
      class Directory < Fog::Model
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
          service.delete_bucket(key)
          true
        rescue Excon::Errors::NotFound
          false
        end

        def files
          @files ||= begin
            Fog::Storage::Google::Files.new(
              :directory    => self,
              :service   => service
            )
          end
        end

        def public=(new_public)
          if new_public
            @acl = 'public-read'
          else
            @acl = 'private'
          end
          new_public
        end

        def public_url
          requires :key
          if service.get_bucket_acl(key).body['AccessControlList'].find {|entry| entry['Scope']['type'] == 'AllUsers' && entry['Permission'] == 'READ'}
            if key.to_s =~ /^(?:[a-z]|\d(?!\d{0,2}(?:\.\d{1,3}){3}$))(?:[a-z0-9]|\.(?![\.\-])|\-(?![\.])){1,61}[a-z0-9]$/
              "https://#{key}.storage.googleapis.com"
            else
              "https://storage.googleapis.com/#{key}"
            end
          else
            nil
          end
        end

        def save
          requires :key
          options = {}
          if @acl
            options['x-goog-acl'] = @acl
          end
          if @location
            options['LocationConstraint'] = @location
          end
          service.put_bucket(key, options)
          true
        end
      end
    end
  end
end
