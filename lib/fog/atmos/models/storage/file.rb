require 'fog/core/model'

module Fog
  module Storage
    class Atmos

      class File < Fog::Model

        identity  :key,             :aliases => :Filename

        attribute :content_length,  :aliases => ['bytes', 'Content-Length'], :type => :integer
        attribute :content_type,    :aliases => ['content_type', 'Content-Type']
        attribute :objectid,        :aliases => :ObjectID

        def body
          attributes[:body] ||= if objectid
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

        def copy(target_directory_key, target_file_key, options={})
          target_directory = service.directories.new(:key => target_directory_key)
          target_directory.files.create(
            :key => target_file_key,
            :body => body
          )
        end

        def destroy
          requires :directory, :key
          service.delete_namespace([directory.key, key].join('/'))
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
          file = directory.files.head(key)
          self.objectid = if file.present? then file.attributes['x-emc-meta'].scan(/objectid=(\w+),/).flatten[0] else nil end
          if self.objectid.present?
            uri = URI::HTTP.build(:scheme => service.ssl? ? "http" : "https" , :host => service.host, :port => service.port.to_i, :path => "/rest/objects/#{self.objectid}" )

            sb = "GET\n"
            sb += uri.path.downcase + "\n"
            sb += service.uid + "\n"
            sb += String(expires.to_i())

            signature = service.sign( sb )
            uri.query = "uid=#{CGI::escape(service.uid)}&expires=#{expires.to_i()}&signature=#{CGI::escape(signature)}"
            uri.to_s
          else
            nil
          end
        end

        def save(options = {})
          requires :body, :directory, :key
          directory.kind_of?(Directory) ? ns = directory.key : ns = directory
          ns += key
          options[:headers] ||= {}
          options[:headers]['Content-Type'] = content_type if content_type
          options[:body] = body
          begin
            data = service.post_namespace(ns, options)
            self.objectid = data.headers['location'].split('/')[-1]
          rescue => error
            if error.message =~ /The resource you are trying to create already exists./
              data = service.put_namespace(ns, options)
            else
              raise error
            end
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
