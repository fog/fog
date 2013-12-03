module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :get_vdc_storage_profile, :get_vdc_storage_class

        # Returns storage class referred by the Id. All properties of the
        # storage classes are visible to vcloud user, except for VDC Storage
        # Class reference.
        #
        # @param [String] id Object identifier of the vDC storage profile.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #     * :href<~String> - The URI of the entity.
        #     * :type<~String> - The MIME type of the entity.
        #     * :id<~String> - The entity identifier, expressed in URN format.
        #       The value of this attribute uniquely identifies the entity,
        #       persists for the life of the entity, and is never reused.
        #     * :name<~String> - The name of the entity.
        #     * :Description<~String> - Optional description.
        #     * :Enabled<~String> - True if this storage profile is enabled for
        #       use in the vDC.
        #     * :Units<~String> - Units used to define :Limit.
        #     * :Limit<~String> - Maximum number of :Units allocated for this
        #       storage profile.
        #     * :Default<~String> - True if this is default storage profile for
        #       this vDC. The default storage profile is used when an object
        #       that can specify a storage profile is created with no storage
        #       profile specified.
        #
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VdcStorageClass.html
        def get_vdc_storage_class(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vdcStorageProfile/#{id}"
          )
        end
      end

      class Mock
        def get_vdc_storage_class(id)
          unless vdc_storage_class = data[:vdc_storage_classes][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"(com.vmware.vcloud.entity.vdcstorageProfile:#{id})\"."
            )
          end

          body =
            {:xmlns=>xmlns,
             :xmlns_xsi=>xmlns_xsi,
             :name=>vdc_storage_class[:name],
             :id=>"urn:vcloud:vdcstorageProfile:#{id}",
             :type=>"application/vnd.vmware.vcloud.vdcStorageProfile+xml",
             :href=>make_href("api/vdcStorageProfile/#{id}"),
             :xsi_schemaLocation=>xsi_schema_location,
             :Link=>
              [{:rel=>"up",
                :type=>"application/vnd.vmware.vcloud.vdc+xml",
                :href=>make_href("vdc/#{vdc_storage_class[:vdc]}")},
               {:rel=>"down",
                :type=>"application/vnd.vmware.vcloud.metadata+xml",
                :href=>make_href("vdcStorageProfile/#{id}/metadata")}],
             :Enabled=>vdc_storage_class[:enabled].to_s,
             :Units=>vdc_storage_class[:units],
             :Limit=>vdc_storage_class[:limit].to_s,
             :Default=>vdc_storage_class[:default].to_s}

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
