require 'fog/core/model'

module Fog
  module Storage
    class Ninefold

      class File < Fog::Model

        identity  :key,             :aliases => :Filename

        attribute :content_length,  :aliases => ['bytes', 'Content-Length'], :type => :integer
        attribute :content_type,    :aliases => ['content_type', 'Content-Type']
        attribute :objectid,        :aliases => :ObjectID

        def body
          attributes[:body] ||= if last_modified
            collection.get(identity).body
          else
            ''
          end
        end

        def body=(new_body)
          attributes[:body] = new_body
        end

        def directory
          @directory
        end

        def destroy
          requires :directory, :key
          connection.delete_namespace([directory.key, key].join('/'))
          true
        end

        # def owner=(new_owner)
        #   if new_owner
        #     attributes[:owner] = {
        #       :display_name => new_owner['DisplayName'],
        #       :id           => new_owner['ID']
        #     }
        #   end
        # end

        def public=(new_public)
          # NOOP - we don't need to flag files as public, getting the public URL for a file handles it.
        end

        # By default, expire in 5 years
        def public_url(expires = (Time.now + 5 * 365 * 24 * 60 * 60))
          requires :objectid
          # TODO - more efficient method to get this?
          storage = Fog::Storage.new(:provider => 'Ninefold')
          uri = URI::HTTP.build(:scheme => Fog::Storage::Ninefold::STORAGE_SCHEME, :host => Fog::Storage::Ninefold::STORAGE_HOST, :port => Fog::Storage::Ninefold::STORAGE_PORT.to_i, :path => "/rest/objects/#{objectid}" )
          Fog::Storage.new(:provider => 'Ninefold').uid


          sb = "GET\n"
          sb += uri.path.downcase + "\n"
          sb += storage.uid + "\n"
          sb += String(expires.to_i())

          signature = storage.sign( sb )
          uri.query = "uid=#{CGI::escape(storage.uid)}&expires=#{expires.to_i()}&signature=#{CGI::escape(signature)}"
          uri.to_s
        end

        def save(options = {})
          requires :body, :directory, :key
          directory.kind_of?(Directory) ? ns = directory.key : ns = directory
          ns += key
          options[:headers] ||= {}
          options[:headers]['Content-Type'] = content_type if content_type
          options[:body] = body
          if objectid
            # pre-existing file, do a PUT
            data = connection.put_namespace(ns, options)
          else
            # new file, POST
            data = connection.post_namespace(ns, options)
            self.objectid = data.headers['location'].split('/')[-1]
          end
          # merge_attributes(data.headers)
          true
        end

        private

        def directory=(new_directory)
          @directory = new_directory
        end

      end

    end
  end
end
