require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/media'

module Fog
  module Compute
    class VcloudDirector
      class Medias < Collection
        model Fog::Compute::VcloudDirector::Media

        attribute :vdc

        # @param [String] name The name of the entity.
        # @param [#read] io The input object to read from.
        # @param [String] image_type Media image type. One of: iso, floppy.
        # @return [Media]
        def create(name, io, image_type='iso')
          requires :vdc

          response = service.post_upload_media(vdc.id, name, image_type, io.size)
          service.add_id_from_href!(response.body)
          media = new(response.body)

          # Perhaps this would be better implemented as media#upload.

          file = response.body[:Files][:File].first
          file[:Link] = [file[:Link]] if file[:Link].is_a?(Hash)
          link = file[:Link].find {|l| l[:rel] == 'upload:default'}

          headers = {
            'Content-Length' => io.size,
            'Content-Type' => 'application/octet-stream',
            'x-vcloud-authorization' => service.vcloud_token
          }
          chunker = lambda do
            # to_s will convert the nil received after everything is read to
            # the final empty chunk.
            io.read(Excon.defaults[:chunk_size]).to_s
          end
          Excon.put(
            link[:href],
            :expects => 200,
            :headers => headers,
            :request_block => chunker)

          service.process_task(response.body[:Tasks][:Task])

          media.reload
          media
        end

        private

        # @param [String] item_id
        # @return [Media]
        def get_by_id(item_id)
          item = service.get_media(item_id).body
          %w(:Link).each {|key_to_delete| item.delete(key_to_delete)}
          service.add_id_from_href!(item)
          item
        end

        # @return [Array<Media>]
        def item_list
          data = service.get_vdc(vdc.id).body
          return [] if data[:ResourceEntities].empty?
          items = data[:ResourceEntities][:ResourceEntity].select do |resource|
            resource[:type] == 'application/vnd.vmware.vcloud.media+xml'
          end
          items.each {|item| service.add_id_from_href!(item)}
          items
        end
      end
    end
  end
end
