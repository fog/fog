require 'fog/core/model'

module Fog
  module AWS
    class Glacier

      class Archive < Fog::Model

        identity  :id
        attribute :description
        attribute :body

        attr_accessor :multipart_chunk_size #must be a power of 2 multiple of 1MB

        def vault
          @vault
        end

        def save
          requires :body, :vault

          if multipart_chunk_size && body.respond_to?(:read)
            self.id = multipart_save
          else
            data = connection.create_archive(vault.id, body, 'description' => description)
            self.id = data.headers['x-amz-archive-id']
          end
          true
        end
        
        def destroy
          requires :id
          connection.delete_archive(vault.id,id)
        end

        private

        def vault=(new_vault)
          @vault = new_vault
        end

        def multipart_save
          # Initiate the upload
          res = connection.initiate_multipart_upload vault.id, multipart_chunk_size, 'description' => description
          upload_id = res.headers["x-amz-multipart-upload-id"]

          hash = Fog::AWS::Glacier::TreeHash.new

          body.rewind if body.respond_to?(:rewind)
          offset = 0
          while (chunk = body.read(multipart_chunk_size)) do
            part_hash = hash.add_part(chunk)
            part_upload = connection.upload_part(vault.id, upload_id, chunk, offset, part_hash  )
            offset += chunk.bytesize
          end

        rescue
          # Abort the upload & reraise
          connection.abort_multipart_upload(vault.id, upload_id) if upload_id
          raise
        else
          # Complete the upload
          connection.complete_multipart_upload(vault.id, upload_id, offset, hash.hexdigest).headers['x-amz-archive-id']
        end

      end

    end
  end
end
