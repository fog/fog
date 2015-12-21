module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a catalog item.
        #
        # @param [String] id Object identifier of the catalog item.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-CatalogItem.html
        # @since vCloud API version 0.9
        def get_catalog_item(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "catalogItem/#{id}"
          )
        end
      end
      class Mock
        def get_catalog_item(id)
          unless item = data[:catalog_items][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"(com.vmware.vcloud.entity.catalogItem:#{id})\"."
            )
          end
          body = {
            :href => make_href("catalogItem/#{id}"),
            :id   => id,
            :name => item[:name],
            :type => 'application/vnd.vmware.vcloud.catalogItem+xml',
            :Entity => {
              :href => make_href("vAppTemplate/#{item[:template_id]}")              
            }
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
