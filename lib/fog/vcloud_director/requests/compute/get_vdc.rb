module Fog
  module Compute
    class VcloudDirector
      class Real
        def get_vdc(vdc_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vdc/#{vdc_id}"
          )
        end
      end

      class Mock
        def get_vdc(vdc_id)
          vdc = data[:vdc]
          raise Excon::Errors::NotFound unless vdc_id == vdc[:uuid]

          body =
            {:xmlns=>xmlns,
             :xmlns_xsi=>xmlns_xsi,
             :status=>"1",
             :name=>vdc[:name],
             :id=>"urn:vcloud:vdc:#{vdc[:uuid]}",
             :type=>"application/vnd.vmware.vcloud.vdc+xml",
             :href=>make_href("vdc/#{vdc[:uuid]}"),
             :xsi_schemaLocation=>xsi_schema_location,
             :Link=>
              [{:rel=>"up",
                :type=>"application/vnd.vmware.vcloud.org+xml",
                :href=>make_href("org/#{data[:org][:uuid]}")},
               {:rel=>"down",
                :type=>"application/vnd.vmware.vcloud.metadata+xml",
                :href=>make_href("vdc/#{vdc[:uuid]}/metadata")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.uploadVAppTemplateParams+xml",
                :href=>
                 make_href("vdc/#{vdc[:uuid]}/action/uploadVAppTemplate")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.media+xml",
                :href=>make_href("vdc/#{vdc[:uuid]}/media")},
               {:rel=>"add",
                :type=>
                 "application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml",
                :href=>
                 make_href("vdc/#{vdc[:uuid]}/action/instantiateVAppTemplate")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.cloneVAppParams+xml",
                :href=>make_href("vdc/#{vdc[:uuid]}/action/cloneVApp")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.cloneVAppTemplateParams+xml",
                :href=>
                 make_href("vdc/#{vdc[:uuid]}/action/cloneVAppTemplate")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.cloneMediaParams+xml",
                :href=>make_href("vdc/#{vdc[:uuid]}/action/cloneMedia")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.captureVAppParams+xml",
                :href=>make_href("vdc/#{vdc[:uuid]}/action/captureVApp")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.composeVAppParams+xml",
                :href=>make_href("vdc/#{vdc[:uuid]}/action/composeVApp")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.diskCreateParams+xml",
                :href=>make_href("vdc/#{vdc[:uuid]}/disk")},
               {:rel=>"edgeGateways",
                :type=>"application/vnd.vmware.vcloud.query.records+xml",
                :href=>make_href("admin/vdc/#{vdc[:uuid]}/edgeGateways")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.vcloud.orgVdcNetwork+xml",
                :href=>make_href("admin/vdc/#{vdc[:uuid]}/networks")},
               {:rel=>"orgVdcNetworks",
                :type=>"application/vnd.vmware.vcloud.query.records+xml",
                :href=>make_href("admin/vdc/#{vdc[:uuid]}/networks")}],
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

          # Emulating Fog::ToHashDocument:
          if data[:networks].size == 1
            body[:AvailableNetworks][:Network] =
              [{:type=>"application/vnd.vmware.vcloud.network+xml",
                :name=>data[:networks].first[:name],
                :href=>make_href("network/#{data[:networks].first[:name]}")}]
          else
            body[:AvailableNetworks][:Network] = data[:networks].map do |network|
              {:type=>"application/vnd.vmware.vcloud.network+xml",
               :name=>network[:name],
               :href=>make_href("network/#{network[:name]}")}
            end
          end

          # Emulating Fog::ToHashDocument:
          if data[:catalog_items].size == 1
            item_type = data[:catalog_items].first[:type]
            body[:ResourceEntities][:ResourceEntity] =
              {:type=>"application/vnd.vmware.vcloud.#{item_type}+xml",
               :name=>data[:catalog_items].first[:name],
               :href=>
                make_href("#{item_type}/#{item_type}-#{data[:catalog_items].first[:uuid]}")}
          else
            body[:ResourceEntities][:ResourceEntity] = data[:catalog_items].map do |catalog_item|
              item_type = catalog_item[:type]
              {:type=>"application/vnd.vmware.vcloud.#{item_type}+xml",
               :name=>catalog_item[:name],
               :href=>
                make_href("#{item_type}/#{item_type}-#{catalog_item[:uuid]}")}
            end
          end

          if api_version.to_f >= 5.1
            # TODO
            #body[:VdcStorageProfiles] =
            # {:VdcStorageProfile=>
            #  [{:type=>"application/vnd.vmware.vcloud.vdcStorageProfile+xml",
            #    :name=>profile[:name],
            #    :href=>make_href("vdcStorageProfile/#{profile[:uuid]}")}]}
          end

          Excon::Response.new(
            :body => body,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :status => 200
          )
        end
      end
    end
  end
end
