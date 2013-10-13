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
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VdcStorageClass.html
        #   vCloud API Documentation
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
          response = Excon::Response.new

          unless vdc_storage_class = data[:vdc_storage_classes][id]
            response.status = 403
            raise Excon::Errors.status_error({:expects => 200}, response)
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

          response.status = 200
          response.headers = {'Content-Type' => "#{body[:type]};version=#{api_version}"}
          response.body = body
          response
        end
      end
    end
  end
end
