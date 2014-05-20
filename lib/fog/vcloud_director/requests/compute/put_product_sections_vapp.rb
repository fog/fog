module Fog
  module Compute
    class VcloudDirector
      class Real
        # Set the value for the specified metadata key to the value provided,
        # overwriting any existing value.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @param [String] key Key of the metadata item.
        # @param [Boolean,DateTime,Fixnum,String] value Value of the metadata
        #   item.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-VAppMetadataItem-metadata.html
        # @since vCloud API version 1.5
        def put_product_sections_vapp(id, sections)
            xml  = '<ProductSectionList xmlns="http://www.vmware.com/vcloud/v1.5" xmlns:ovf="http://schemas.dmtf.org/ovf/envelope/1">'
            xml += '<ovf:ProductSection>'
            xml += '<ovf:Info>Global vApp Custom Properties</ovf:Info>'
            xml += '<ovf:Category>Global</ovf:Category>'

            sections.each do |section|
              section[:user_configurable] ||= true
              section[:type]              ||= "string"
              section[:password]          ||= false
              xml += "<ovf:Property ovf:userConfigurable='#{section[:user_configurable]}' ovf:type='#{section[:type]}' ovf:password='#{section[:password]}' ovf:key='#{section[:id]}' ovf:value='#{section[:value]}'/>"
            end

            xml += '</ovf:ProductSection>'
            xml += "</ProductSectionList>"
            puts xml

          request(
            :body    => xml,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.productSections+xml'},
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/productSections"
          )
        end
      end
    end
  end
end
