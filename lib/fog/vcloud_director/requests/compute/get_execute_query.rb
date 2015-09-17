module Fog
  module Compute
    class VcloudDirector
      class Real
        # REST API General queries handler.
        #
        # @param [String] type The type of the query. Type names are
        #   case-sensitive. You can retrieve a summary list of all typed
        #   queries types accessible to the currently authenticated user by
        #   making a request with type=nil.
        # @param [Hash] options
        # @option options [String] :sortAsc (Sorted by database ID) Sort
        #   results by attribute-name in ascending order. attribute-name cannot
        #   include metadata.
        # @option options [String] :sortDesc (Sorted by database ID) Sort
        #   results by attribute-name in descending order. attribute-name
        #   cannot include metadata.
        # @option options [Integer] :page (1) If the query results span
        #   multiple pages, return this page.
        # @option options [Integer] :pageSize (25) Number of results per page,
        #   to a maximum of 128.
        # @option options [String] :format (records) One of the following
        #   types:
        #   - *references* Returns a reference to each object, including its
        #     :name, :type, and :href attributes.
        #   - *records* Returns all database records for each object, with each
        #     record as an attribute.
        #   - *idrecords* Identical to the records format, except that object
        #     references are returned in :id format rather than :href format.
        # @option options [Array<String>] :fields (all static attribute names)
        #   List of attribute names or metadata key names to return.
        # @option options [Integer] :offset (0) Integer value specifying the
        #   first record to return. Record numbers < offset are not returned.
        # @option options [String] :filter (none) Filter expression.
        # @return [Excon::Response] if type is specified.
        #   * hash<~Hash>:
        #     * :href<~String> - The URI of the entity.
        #     * :type<~String> - The MIME type of the entity.
        #     * :name<~String> - Query name that generated this result set.
        #     * :page<~String> - Page of the result set that this container
        #       holds. The first page is page number 1.
        #     * :pageSize<~String> - Page size, as a number of records or
        #       references.
        #     * :total<~String> - Total number of records or references in the
        #       container.
        #     * :Link<~Array<Hash>>:
        #       * :href<~String> - Contains the URI to the entity.
        #       * :type<~String> - Contains the type of the entity.
        #       * :rel<~String> - Defines the relationship of the link to the
        #         object that contains it.
        #     * :Record<~Array<Hash>> - The name and content of this item
        #       varies according to the type and format of the query.
        #     * :firstPage<~Integer> - First page in the result set.
        #     * :previousPage<~Integer> - Previous page in the result set.
        #     * :nextPage<~Integer> - Next page in the result set.
        #     * :lastPage<~Integer> - Last page in the result set.
        # @return [Excon::Response] if type is nil.
        #   * hash<~Hash>:
        #     * :href<~String> - The URI of the entity.
        #     * :type<~String> - The MIME type of the entity.
        #     * :Link<~Array<Hash>>:
        #       * :href<~String> - Contains the URI to the entity.
        #       * :name<~String> - Contains the name of the entity.
        #       * :type<~String> - Contains the type of the entity.
        #       * :rel<~String> - Defines the relationship of the link to the
        #         object that contains it.
        #
        # @see http://pubs.vmware.com/vcd-55/topic/com.vmware.vcloud.api.reference.doc_55/doc/operations/GET-ExecuteQuery.html
        # @since vCloud API version 1.5
        def get_execute_query(type=nil, options={})
          if type.nil?
            response = request(
              :expects    => 200,
              :idempotent => true,
              :method     => 'GET',
              :parser     => Fog::ToHashDocument.new,
              :path       => 'query'
            )
          else
            query = {
              :type => type,
            }

            query[:sortAsc] = options[:sortAsc] if options[:sortAsc]
            query[:sortDesc] = options[:sortDesc] if options[:sortDesc]
            query[:page] = options[:page] if options[:page]
            query[:pageSize] = options[:pageSize] if options[:pageSize]
            query[:format] = options[:format] if options[:format]
            query[:fields] = Array(options[:fields]).join(',') if options[:fields]
            query[:offset] = options[:offset] if options[:offset]
            query[:filter] = options[:filter] if options[:filter]

            response = request(
              :expects    => 200,
              :idempotent => true,
              :method     => 'GET',
              :parser     => Fog::ToHashDocument.new,
              :path       => 'query',
              :query      => query.map {|k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join('&').gsub('%3D', '=').gsub('%3B', ';')
            )
            ensure_list! response.body, :Link
            # TODO: figure out the right key (this isn't it)
            #ensure_list! response.body,
            #  response.body[:type] == 'application/vnd.vmware.vcloud.query.references+xml' ?
            #    "#{response.body[:name]}Reference".to_sym :
            #    "#{response.body[:name]}Record".to_sym

            %w[firstPage previousPage nextPage lastPage].each do |rel|
              if link = response.body[:Link].find {|l| l[:rel] == rel}
                href = Nokogiri::XML.fragment(link[:href])
                query = CGI.parse(URI.parse(href.text).query)
                response.body[rel.to_sym] = query['page'].first.to_i
                response.body[:pageSize] ||= query['pageSize'].first.to_i
              end
            end

            response
          end
        end
      end

      class Mock
        def get_execute_query(type=nil, options={})
          unless options[:fields].nil?
            Fog::Mock.not_implemented("Fields are not yet implemented in get_execute_query Mock for #{type}")
          end

          unless options[:format].nil? || options[:format] == 'records'
            Fog::Mock.not_implemented("Formats #{options[:format]} is not yet implemented in get_execute_query Mock for #{type}")
          end

          # NB: default is to sort by 'Database ID' (uuid?). Does this matter?
          unless options[:sortAsc].nil? && options[:sortDesc].nil?
            Fog::Mock.not_implemented("Sorting by field is not yet implemented in get_execute_query Mock for #{type}")
          end

          # NB: default offset is 0
          unless options[:offset].nil?
            Fog::Mock.not_implemented("Offset results are not yet implemented in get_execute_query Mock for #{type}")
          end

          # NB: default page is 1
          if options.key?(:page) && options[:page].to_i != 1
            Fog::Mock.not_implemented("Paginated results are not yet implemented in get_execute_query Mock for #{type}")
          end

          # NB: default pageSize is 25
          unless options[:pageSize].nil?
            Fog::Mock.not_implemented("Paginated results are not yet implemented in get_execute_query Mock for #{type}")
          end

          if type.nil?
            body = all_types
          else
            body = fetch_items(type, options)
          end

          Excon::Response.new(
            :status  => 200,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body    => body
          )
        end

        private

        def fetch_items(type, opts)
          if opts.key?(:filter) && opts[:filter] =~ /^name==([^;,]+)$/
            name = $1
          elsif type == 'vAppTemplate' && opts.key?(:filter) &&
            opts[:filter] =~ /^name==([^;,]+);catalogName==([^;,]+)$/ #TODO also match in other order
            name = $1
            catalog_name = $2
          elsif opts.key?(:filter)
            Fog::Mock.not_implemented("Complex filters are not yet implemented in get_execute_query Mock for #{type}: #{opts[:filter]}")
          end

          body = {
            :xmlns=>xmlns,
            :xmlns_xsi=>xmlns_xsi,
            :href=>make_href('query'),
            :name=>type,
            :type=>"application/vnd.vmware.vcloud.query.records+xml",
            :xsi_schemaLocation=>xsi_schema_location,
          }

          records = []
          record_type = nil

          if type == 'orgVdc'
            record_type = :OrgVdcRecord
            vdc_id = data[:vdcs].keys[0]
            vdc_name = data[:vdcs][vdc_id][:name]
            records = [{
              :storageUsedMB=>"123967",
              :storageLimitMB=>"8388608",
              :storageAllocationMB=>"0",
              :status=>"READY",
              :orgName=>"orgName",
              :name=>vdc_name,
              :memoryUsedMB=>"0",
              :memoryLimitMB=>"0",
              :memoryAllocationMB=>"0",
              :isSystemVdc=>"false",
              :isEnabled=>"true",
              :isBusy=>"false",
              :href=>make_href("vdc/#{vdc_id}"),
            }]
            body[:page]     = 1.to_s             # TODO: Support pagination
            body[:pageSize] = records.size.to_s  # TODO: Support pagination
            body[:total]    = records.size.to_s
            body[record_type] = records

          elsif type == 'orgVdcNetwork'
            record_type = :OrgVdcNetworkRecords
            data_type = :networks
            data[data_type].each do |id, dr|
              r = {}
              if name.nil? || dr[:name] == name
                vdc_id = dr[:vdc]
                if data[:vdcs][vdc_id] && data[:vdcs][vdc_id].key?(:name)
                  r[:vdcName] = data[:vdcs][vdc_id][:name]
                end
                r[:name] = dr[:name]
                r[:vdc]  = make_href("vdc/#{vdc_id}") if vdc_id
                r[:href] = make_href("admin/network/#{id}")
                mapping = {
                  :description    => :Description,
                  :netmask        => :Netmask,
                  :linkType       => :LinkType,
                  :dns1           => :Dns1,
                  :dns2           => :Dns2,
                  :dnsSuffix      => :DnsSuffix,
                  :defaultGateway => :Gateway,
                  :isShared       => :IsShared,
                  :isBusy         => :IsBusy,
                  :isIpScopeInherited => :IsIpScopeInherited,
                }

                mapping.each do |k,v|
                  r[k] = dr[v] if dr.key?(v)
                end

                records << r
              end
            end
            body[:page]     = 1.to_s             # TODO: Support pagination
            body[:pageSize] = records.size.to_s  # TODO: Support pagination
            body[:total]    = records.size.to_s
            body[record_type] = records

          elsif type == 'edgeGateway'
            record_type = :EdgeGatewayRecord
            edge_gateway_id = data[:edge_gateways].keys[0]
            vdc_id = data[:edge_gateways][edge_gateway_id][:vdc]
            records = [{
              :vdc=>make_href("vdc/#{vdc_id}"),
              :numberOfOrgNetworks=>"1",
              :numberOfExtNetworks=>"1",
              :name=>"Test EdgeGateway Name",
              :isBusy=>"false",
              :haStatus=>"DISABLED",
              :gatewayStatus=>"READY",
              :href=>make_href("edgeGateway/#{edge_gateway_id}"),
              :taskStatus=>"success",
              :taskOperation=>"networkConfigureEdgeGatewayServices",
              :task=>make_href("task/#{uuid}"),
              :taskDetails=>" "
            }]
            body[:page]     = 1.to_s             # TODO: Support pagination
            body[:pageSize] = records.size.to_s  # TODO: Support pagination
            body[:total]    = records.size.to_s
            body[record_type] = records

          elsif type == 'vAppTemplate'
            record_type = :VAappTemplateRecord
            records = [{
              :vdcName=>"Bogus vDC",
              :vdc=>make_href("vdc/#{uuid}"),
              :storageProfileName=>"*",
              :status=>"RESOLVED",
              :ownerName=>"system",
              :org=> make_href("org/#{data[:org][:uuid]}"),
              :name=> name,
              :isPublished=>"true",
              :isGoldMaster=>"false",
              :isExpired=>"false",
              :isEnabled=>"true",
              :isDeployed=>"false",
              :isBusy=>"false",
              :creationDate=>"2013-09-19T22:55:30.257+01:00",
              :catalogName=> catalog_name,
              :href=> make_href("vAppTemplate/vappTemplate-#{uuid}"),
              :honorBootOrder=>"false",
              :isVdcEnabled=>"true",
              :isInCatalog=>"true",
              :cpuAllocationMhz=>"8",
              :cpuAllocationInMhz=>"16000",
              :storageKB=>"52428800",
              :numberOfShadowVMs=>"0",
              :numberOfVMs=>"1",
              :isAutoDeleteNotified=>"false",
              :numberOfCpus=>"8",
              :isAutoUndeployNotified=>"false",
              :memoryAllocationMB=>"32768"
            }]
            body[:page]     = 1.to_s             # TODO: Support pagination
            body[:pageSize] = records.size.to_s  # TODO: Support pagination
            body[:total]    = records.size.to_s
            body[record_type] = records

          elsif type == 'vApp'
            record_type = :VAppRecord
            all_records = data[:vapps].map do |vapp_id, vapp|
              {
                :vdcName => data.fetch(:vdcs).fetch(vapp[:vdc_id]).fetch(:name),
                :vdc => make_href("vdc/#{vapp[:vdc_id]}"),
                :storageProfileName => "*",
                :ownerName => "system",
                :name => vapp.fetch(:name),
                :status => 'POWERED_OFF',
                :isInMaintenanceMode=> 'false',
                :isPublic => 'false',
                :isExpired =>"false",
                :isEnabled =>"true",
                :isDeployed =>"false",
                :isBusy => "false",
                :pvdcHighestSupportedHardwareVersion => '8',
                :lowestHardwareVersionInVApp => '8',
                :creationDate => "2013-09-19T22:55:30.257+01:00",
                :href => make_href("vApp/#{vapp_id}"),
                :honorBootOrder => "false",
                :isVdcEnabled => "true",
                :cpuAllocationMhz => "8",
                :cpuAllocationInMhz => "16000",
                :storageKB => "52428800",
                :numberOfVMs => "1",
                :isAutoDeleteNotified => "false",
                :numberOfCpus => "8",
                :isAutoUndeployNotified => "false",
                :memoryAllocationMB => "32768",
                :task => make_href("task/#{uuid}"),
                :taskStatusName => 'vdcInstantiateVapp',
                :taskStatus => 'success',
                :taskDetails => " ",
              }
            end
            records = all_records.select do |record|
              record[:name] == name
            end

            body[:page]     = 1.to_s             # TODO: Support pagination
            body[:pageSize] = records.size.to_s  # TODO: Support pagination
            body[:total]    = records.size.to_s
            body[record_type] = records

          elsif type == 'task'

            record_type = :TaskRecord
            data_type = :tasks
            data[data_type].each do |id, dr|
              r = {}
              if name.nil? || dr.fetch(:operation_name) == name
                r[:name] = dr.fetch(:operation_name)
                r[:href] = make_href("task/#{id}")
                if dr.key?(:end_time)
                  r[:endDate] = dr.fetch(:end_time).strftime('%Y-%m-%dT%H:%M:%S%z')
                else
                  r[:endDate] = nil
                end
                if dr.key?(:start_time)
                  r[:startDate] = dr.fetch(:start_time).strftime('%Y-%m-%dT%H:%M:%S%z')
                else
                  r[:startDate] = nil
                end
                r[:status] = dr.fetch(:status)
                r[:serviceNamespace] = 'com.vmware.vcloud'
                r[:ownerName] = '000.0.000000'
                r[:orgName] = data.fetch(:org).fetch(:name)
                r[:org] = make_href("org/#{data[:org][:uuid]}")
                r[:objectType] = dr.fetch(:owner).fetch(:type).split(/\./).last.split(/\+/).first
                r[:objectName] = dr.fetch(:owner).fetch(:name, '') # objectName is optional
                r[:object] = dr.fetch(:owner).fetch(:href)
                r[:details] = '! []'

                records << r
              end
            end

          else
            Fog::Mock.not_implemented("No 'get by name' get_execute_query Mock for #{type} (#{name})")
          end

          body[:page]     = 1.to_s             # TODO: Support pagination
          body[:pageSize] = records.size.to_s  # TODO: Support pagination
          body[:total]    = records.size.to_s
          body[record_type] = records

          body
        end

        def all_types
          {:xmlns=>xmlns,
           :xmlns_xsi=>xmlns_xsi,
           :type=>"application/vnd.vmware.vcloud.query.queryList+xml",
           :href=>make_href('query'),
           :xsi_schemaLocation=>xsi_schema_location,
           :Link=>
            [{:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"organization",
              :href=>make_href('query?type=organization&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"organization",
              :href=>make_href('query?type=organization&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"organization",
              :href=>make_href('query?type=organization&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"orgVdc",
              :href=>make_href('query?type=orgVdc&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"orgVdc",
              :href=>make_href('query?type=orgVdc&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"orgVdc",
              :href=>make_href('query?type=orgVdc&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"media",
              :href=>make_href('query?type=media&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"media",
              :href=>make_href('query?type=media&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"media",
              :href=>make_href('query?type=media&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"vAppTemplate",
              :href=>make_href('query?type=vAppTemplate&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"vAppTemplate",
              :href=>make_href('query?type=vAppTemplate&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"vAppTemplate",
              :href=>make_href('query?type=vAppTemplate&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"vApp",
              :href=>make_href('query?type=vApp&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"vApp",
              :href=>make_href('query?type=vApp&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"vApp",
              :href=>make_href('query?type=vApp&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"vm",
              :href=>make_href('query?type=vm&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"vm",
              :href=>make_href('query?type=vm&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"vm",
              :href=>make_href('query?type=vm&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"orgNetwork",
              :href=>make_href('query?type=orgNetwork&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"orgNetwork",
              :href=>make_href('query?type=orgNetwork&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"orgNetwork",
              :href=>make_href('query?type=orgNetwork&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"vAppNetwork",
              :href=>make_href('query?type=vAppNetwork&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"vAppNetwork",
              :href=>make_href('query?type=vAppNetwork&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"vAppNetwork",
              :href=>make_href('query?type=vAppNetwork&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"catalog",
              :href=>make_href('query?type=catalog&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"catalog",
              :href=>make_href('query?type=catalog&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"catalog",
              :href=>make_href('query?type=catalog&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"group",
              :href=>make_href('query?type=group&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"group",
              :href=>make_href('query?type=group&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"group",
              :href=>make_href('query?type=group&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"user",
              :href=>make_href('query?type=user&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"user",
              :href=>make_href('query?type=user&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"user",
              :href=>make_href('query?type=user&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"strandedUser",
              :href=>make_href('query?type=strandedUser&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"strandedUser",
              :href=>make_href('query?type=strandedUser&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"strandedUser",
              :href=>make_href('query?type=strandedUser&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"role",
              :href=>make_href('query?type=role&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"role",
              :href=>make_href('query?type=role&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"role",
              :href=>make_href('query?type=role&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"allocatedExternalAddress",
              :href=>make_href('query?type=allocatedExternalAddress&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"allocatedExternalAddress",
              :href=>make_href('query?type=allocatedExternalAddress&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"event",
              :href=>make_href('query?type=event&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"event",
              :href=>make_href('query?type=event&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"right",
              :href=>make_href('query?type=right&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"right",
              :href=>make_href('query?type=right&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"right",
              :href=>make_href('query?type=right&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"vAppOrgNetworkRelation",
              :href=>make_href('query?type=vAppOrgNetworkRelation&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"vAppOrgNetworkRelation",
              :href=>make_href('query?type=vAppOrgNetworkRelation&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"vAppOrgNetworkRelation",
              :href=>make_href('query?type=vAppOrgNetworkRelation&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"catalogItem",
              :href=>make_href('query?type=catalogItem&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"catalogItem",
              :href=>make_href('query?type=catalogItem&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"catalogItem",
              :href=>make_href('query?type=catalogItem&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"task",
              :href=>make_href('query?type=task&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"task",
              :href=>make_href('query?type=task&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"task",
              :href=>make_href('query?type=task&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"disk",
              :href=>make_href('query?type=disk&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"disk",
              :href=>make_href('query?type=disk&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"disk",
              :href=>make_href('query?type=disk&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"vmDiskRelation",
              :href=>make_href('query?type=vmDiskRelation&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"vmDiskRelation",
              :href=>make_href('query?type=vmDiskRelation&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"service",
              :href=>make_href('query?type=service&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"service",
              :href=>make_href('query?type=service&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"service",
              :href=>make_href('query?type=service&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"orgVdcStorageProfile",
              :href=>make_href('query?type=orgVdcStorageProfile&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"orgVdcStorageProfile",
              :href=>make_href('query?type=orgVdcStorageProfile&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"orgVdcStorageProfile",
              :href=>make_href('query?type=orgVdcStorageProfile&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"apiDefinition",
              :href=>make_href('query?type=apiDefinition&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"apiDefinition",
              :href=>make_href('query?type=apiDefinition&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"apiDefinition",
              :href=>make_href('query?type=apiDefinition&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"fileDescriptor",
              :href=>make_href('query?type=fileDescriptor&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"fileDescriptor",
              :href=>make_href('query?type=fileDescriptor&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"edgeGateway",
              :href=>make_href('query?type=edgeGateway&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"edgeGateway",
              :href=>make_href('query?type=edgeGateway&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"edgeGateway",
              :href=>make_href('query?type=edgeGateway&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"orgVdcNetwork",
              :href=>make_href('query?type=orgVdcNetwork&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"orgVdcNetwork",
              :href=>make_href('query?type=orgVdcNetwork&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"orgVdcNetwork",
              :href=>make_href('query?type=orgVdcNetwork&#38;format=idrecords')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.references+xml",
              :name=>"vAppOrgVdcNetworkRelation",
              :href=>make_href('query?type=vAppOrgVdcNetworkRelation&#38;format=references')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.records+xml",
              :name=>"vAppOrgVdcNetworkRelation",
              :href=>make_href('query?type=vAppOrgVdcNetworkRelation&#38;format=records')},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.query.idrecords+xml",
              :name=>"vAppOrgVdcNetworkRelation",
              :href=>make_href('query?type=vAppOrgVdcNetworkRelation&#38;format=idrecords')}
            ]
          }
        end

      end
    end
  end
end
