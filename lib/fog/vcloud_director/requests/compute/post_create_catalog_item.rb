module Fog
  module Compute
    class VcloudDirector
      class Real
        # Add an item to a catalog.
        #
        # @param [String] id Object identifier of the catalog.
        # @param [String] name The name of the entity.
        # @param [Hash] entity A reference to a VAppTemplate or Media object.
        #   * href<~String> - Contains the URI to the entity.
        # @param [Hash] options
        # @option options [String] :operationKey Optional unique identifier to
        #   support idempotent semantics for create and delete operations.
        # @option options [String] :Description Optional description.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise Fog::Compute::VcloudDirector::DuplicateName
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-CreateCatalogItem.html
        # @since vCloud API version 0.9
        def post_create_catalog_item(id, name, entity, options={})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              :name => name,
            }
            attrs[:operationKey] = options[:operationKey] if options.key?(:operationKey)
            CatalogItem(attrs) {
              if options.key?(:Description)
                Description options[:Description]
              end
              Entity(entity)
            }
          end.to_xml

          begin
            request(
              :body    => body,
              :expects => 201,
              :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.catalogItem+xml'},
              :method  => 'POST',
              :parser  => Fog::ToHashDocument.new,
              :path    => "catalog/#{id}/catalogItems"
            )
          rescue Fog::Compute::VcloudDirector::BadRequest => e
            if e.minor_error_code == 'DUPLICATE_NAME'
              raise Fog::Compute::VcloudDirector::DuplicateName.new(e.message)
            end
            raise
          end
        end
      end
    end
  end
end
