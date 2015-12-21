module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a catalog.
        #
        # @param [String] id Object identifier of the catalog.
        # @return [Excon::Response]
        #   * hash<~Hash>:
        #
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Catalog.html
        # @since vCloud API version 0.9
        def get_catalog(id)
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "catalog/#{id}"
          )
          ensure_list! response.body, :CatalogItems, :CatalogItem
          response
        end
      end

      class Mock
        def get_catalog(id)
          unless catalog = data[:catalogs][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"(com.vmware.vcloud.entity.catalog:#{id})\"."
            )
          end
          
          items = data[:catalog_items].select {|_,v| v[:catalog] == id}
          
          body = {
            :href => make_href("catalog/#{id}"),
            :type => 'application/vnd.vmware.vcloud.catalog+xml',
            :id   => id,
            :name => catalog[:name],
            :CatalogItems => {
              :CatalogItem => items.map do |uuid,item|
                {
                  :href => make_href("catalogItem/#{uuid}"),
                  :id   => uuid,
                  :name => item[:name],
                  :type => 'application/vnd.vmware.vcloud.catalogItem+xml'
                }
              end
            },
          }
          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end
      end
    end
  end
end
