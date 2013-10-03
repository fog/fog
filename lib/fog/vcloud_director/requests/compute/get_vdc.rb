module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a vDC.
        #
        # @param [String] vdc_id Object identifier of the vDC.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Vdc.html
        #   vCloud API Documentation
        # @since vCloud API version 0.9
        def get_vdc(vdc_id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vdc/#{vdc_id}"
          )
        end
      end

      class Mock
        def get_vdc(vdc_id)
          response = Excon::Response.new

          unless valid_uuid?(vdc_id)
            response.status = 400
            raise Excon::Errors.status_error({:expects => 200}, response)
          end
          unless vdc = data[:vdcs][vdc_id]
            response.status = 403
            raise Excon::Errors.status_error({:expects => 200}, response)
          end

          body =
            {:xmlns=>xmlns,
             :xmlns_xsi=>xmlns_xsi,
             :status=>"1",
             :name=>vdc[:name],
             :id=>"urn:vcloud:vdc:#{vdc_id}",
             :type=>"application/vnd.vmware.vcloud.vdc+xml",
             :href=>make_href("vdc/#{vdc_id}"),
             :xsi_schemaLocation=>xsi_schema_location,
             :Link=>
              [{:rel=>"up",
                :type=>"application/vnd.vmware.vcloud.org+xml",
                :href=>make_href("org/#{data[:org][:uuid]}")},
               {:rel=>"down",
                :type=>"application/vnd.vmware.vcloud.metadata+xml",
                :href=>make_href("vdc/#{vdc_id}/metadata")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.uploadVAppTemplateParams+xml",
                :href=>
                 make_href("vdc/#{vdc_id}/action/uploadVAppTemplate")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.media+xml",
                :href=>make_href("vdc/#{vdc_id}/media")},
               {:rel=>"add",
                :type=>
                 "application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml",
                :href=>
                 make_href("vdc/#{vdc_id}/action/instantiateVAppTemplate")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.cloneVAppParams+xml",
                :href=>make_href("vdc/#{vdc_id}/action/cloneVApp")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.cloneVAppTemplateParams+xml",
                :href=>
                 make_href("vdc/#{vdc_id}/action/cloneVAppTemplate")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.cloneMediaParams+xml",
                :href=>make_href("vdc/#{vdc_id}/action/cloneMedia")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.captureVAppParams+xml",
                :href=>make_href("vdc/#{vdc_id}/action/captureVApp")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.composeVAppParams+xml",
                :href=>make_href("vdc/#{vdc_id}/action/composeVApp")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.diskCreateParams+xml",
                :href=>make_href("vdc/#{vdc_id}/disk")},
               {:rel=>"edgeGateways",
                :type=>"application/vnd.vmware.vcloud.query.records+xml",
                :href=>make_href("admin/vdc/#{vdc_id}/edgeGateways")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.orgVdcNetwork+xml",
                :href=>make_href("admin/vdc/#{vdc_id}/networks")},
               {:rel=>"orgVdcNetworks",
                :type=>"application/vnd.vmware.vcloud.query.records+xml",
                :href=>make_href("admin/vdc/#{vdc_id}/networks")}],
             :Description=>vdc[:description]||'',
             :AllocationModel=>"AllocationVApp",
             :ComputeCapacity=>
              {:Cpu=>
               {:Units=>"MHz",
                :Allocated=>"0",
                :Limit=>"0",
                :Reserved=>"0",
                :Used=>"0",
                :Overhead=>"0"},
              :Memory=>
               {:Units=>"MB",
                :Allocated=>"0",
                :Limit=>"0",
                :Reserved=>"0",
                :Used=>"0",
                :Overhead=>"0"}},
             :ResourceEntities => {},
             :AvailableNetworks => {},
             :Capabilities=>
              {:SupportedHardwareVersions=>
               {:SupportedHardwareVersion=>"vmx-08"}},
             :NicQuota=>"0",
             :NetworkQuota=>"20",
             :UsedNetworkCount=>"0",
             :VmQuota=>"100",
             :IsEnabled=>"true"}

          networks = data[:networks].map do |id, network|
            {:type=>"application/vnd.vmware.vcloud.network+xml",
             :name=>network[:name],
             :href=>make_href("network/#{id}")}
          end
          networks = networks.first if networks.size == 1
          body[:AvailableNetworks][:Network] = networks

          resources = data[:catalog_items].map do |id, item|
            {:type=>"application/vnd.vmware.vcloud.#{item[:type]}+xml",
             :name=>item[:name],
             :href=>
              make_href("#{item[:type]}/#{item[:type]}-#{id}")}
          end
          resources = resources.first if resources.size == 1
          body[:ResourceEntities][:ResourceEntity] = resources

          if api_version.to_f >= 5.1
            # TODO
            #body[:VdcStorageProfiles] =
            # {:VdcStorageProfile=>
            #  [{:type=>"application/vnd.vmware.vcloud.vdcStorageProfile+xml",
            #    :name=>profile[:name],
            #    :href=>make_href("vdcStorageProfile/#{profile[:uuid]}")}]}
          end

          response.status = 200
          response.headers = {'Content-Type' => "#{body[:type]};version=#{api_version}"}
          response.body = body
          response
        end
      end
    end
  end
end
