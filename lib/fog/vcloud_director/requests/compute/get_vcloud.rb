module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve an administrative view of a cloud.
        #
        # The VCloud element provides access to cloud-wide namespace of objects
        # that an administrator can view and, in most cases, modify.
        #
        # @return [Excon:Response]
        #   * body<~Hash>:
        #     * :href<~String> - The URI of the entity.
        #     * :type<~String> - The MIME type of the entity.
        #     * :name<~String> - The name of the entity.
        #     * :Description<~String> - Optional description.
        #     * :OrganizationReferences<Hash>:
        #       * :OrganizationReference<~Array<Hash>>:
        #         * :href<~String> - Contains the URI to the entity.
        #         * :name<~String> - Contains the name of the entity.
        #         * :type<~String> - Contains the type of the entity.
        #     * :ProviderVdcReferences<~Hash>:
        #       * :ProviderVdcReferences<~Array<Hash>>:
        #     * :RightReferences<~Hash>:
        #       * :RightReferences<~Array<Hash>>:
        #     * :RoleReferences<~Hash>:
        #       * :RoleReferences<~Array<Hash>>:
        #     * :Networks<~Hash>:
        #       * :Network<~Array<Hash>>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Vcloud.html
        # @since vCloud API version 0.9
        def get_vcloud
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => 'admin/'
          )
          ensure_list! response.body, :OrganizationReferences, :OrganizationReference
          ensure_list! response.body, :ProviderVdcReferences, :ProviderVdcReference
          ensure_list! response.body, :RightReferences, :RightReference
          ensure_list! response.body, :RoleReferences, :RoleReference
          ensure_list! response.body, :Networks, :Network
          response
        end
      end

      class Mock
        def get_vcloud
          body =
            {:href=>make_href('admin/'),
             :type=>"application/vnd.vmware.admin.vcloud+xml",
             :name=>'VMware vCloud Director',
             :Description=>'5.1.2.1377223 Tue Oct 15 20:56:05 GMT 2013',
             :Tasks=>{:Task=>[]},
             :OrganizationReferences=>
              {:OrganizationReference=>
               [{:type=>"application/vnd.vmware.admin.organization+xml",
                 :name=>data[:org][:name],
                 :href=>make_href("api/admin/org/#{data[:org][:uuid]}")}]},
             :ProviderVdcReferences=>{:ProviderVdcReference=>[]},
             :RightReferences=>{:RightReference=>[]},
             :RoleReferences=>{:RoleReference=>[]},
             :Networks=>{:Network=>[]}}

          Excon::Response.new(
            :body    => body,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :status  => 200
          )
        end
      end
    end
  end
end
