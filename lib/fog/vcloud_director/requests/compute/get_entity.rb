module Fog
  module Compute
    class VcloudDirector
      class Real
        # Redirects to the URL of an entity with the given VCD ID.
        #
        # @param [String] id
        # @return [Excon:Response]
        #   * body<~Hash>:
        #     * :href<~String> - The URI of the entity.
        #     * :type<~String> - The MIME type of the entity.
        #     * :id<~String> - The entity identifier, expressed in URN format.
        #       The value of this attribute uniquely identifies the entity,
        #       persists for the life of the entity, and is never reused.
        #     * :name<~String> - The name of the entity.
        #     * :Link<~Array<Hash>]:
        #       * :href<~String> - Contains the URI to the linked entity.
        #       * :type<~String> - Contains the type of the linked entity.
        #       * :rel<~String> - Defines the relationship of the link to the
        #         object that contains it.
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Entity.html
        # @since vCloud API version 1.5
        def get_entity(id)
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "entity/#{id}"
          )
          ensure_list! response.body, :Link
          response
        end
      end
    end
  end
end
