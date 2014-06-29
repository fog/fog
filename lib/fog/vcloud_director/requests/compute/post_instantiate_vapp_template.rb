module Fog
  module Compute
    class VcloudDirector
      class Real
        # Create a vApp from a vApp template.
        #
        # The response includes a Task element. You can monitor the task to to
        # track the creation of the vApp.
        #
        # @note This may not work at all or may work only under certain
        #   circumstances.
        #
        # @param [String] id Object identifier of the vDC.
        # @param [String] vapp_template_id Object identifier of the vApp
        #   template.
        # @param [String] name
        # @param [Hash] options
        # @option options [Boolean] :deploy True if the vApp should be deployed
        #   at instantiation. Defaults to true.
        # @option options [Boolean] :powerOn True if the vApp should be
        #   powered-on at instantiation. Defaults to true.
        # @option options [String] :Description Optional description.
        # @option options [Hash] :InstantiationParams Instantiation parameters
        #   for the composed vApp.
        #   * :LeaseSettingsSection<~Hasn>:
        #     * :DeploymentLeaseTimeInSeconds<~Integer> - Deployment lease in
        #       seconds.
        #     * :StorageLeaseTimeInSeconds<~Integer> - Storage lease in
        #       seconds.
        #     * :DeploymentLeaseExpiration<~Integer> - Expiration date/time of
        #       deployment lease.
        #     * :StorageLeaseExpiration<~Integer> - Expiration date/time of
        #       storage lease.
        #   * :NetworkConfigSection<~Hash>:
        #     * :NetworkConfig<~Hash>:
        #       * :networkName<~String> - The name of the vApp network.
        #       * :Configuration<~Hash>:
        #         * :ParentNetwork<~Hash>:
        #           * :href<~String> -
        #         * :FenceMode<~String> - Isolation type of the network.
        # @option options [Boolean] :IsSourceDelete Set to true to delete the
        #   source object after the operation completes.
        # @option options [Boolean] :AllEULAsAccepted True confirms acceptance
        #   of all EULAs in a vApp template.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise Fog::Compute::VcloudDirector::DuplicateName
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-InstantiateVAppTemplate.html
        # @since vCloud API version 0.9
        def post_instantiate_vapp_template(id, vapp_template_id, name, options={})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              'xmlns' => 'http://www.vmware.com/vcloud/v1.5',
              'xmlns:ovf' => 'http://schemas.dmtf.org/ovf/envelope/1',
              :name => name
            }
            attrs[:deploy] = options[:deploy] if options.key?(:deploy)
            attrs[:powerOn] = options[:powerOn] if options.key?(:powerOn)
            InstantiateVAppTemplateParams(attrs) {
              if options.key?(:Description)
                Description options[:Description]
              end
              if instantiation_params = options[:InstantiationParams]
                InstantiationParams {
                  if section = instantiation_params[:LeaseSettingsSection]
                    LeaseSettingsSection {
                      self['ovf'].Info 'Lease settings section'
                      if section.key?(:DeploymentLeaseInSeconds)
                        DeploymentLeaseInSeconds section[:DeploymentLeaseInSeconds]
                      end
                      if section.key?(:StorageLeaseInSeconds)
                        StorageLeaseInSeconds section[:StorageLeaseInSeconds]
                      end
                      if section.key?(:DeploymentLeaseExpiration)
                        DeploymentLeaseExpiration section[:DeploymentLeaseExpiration].strftime('%Y-%m-%dT%H:%M:%S%z')
                      end
                      if section.key?(:StorageLeaseExpiration)
                        StorageLeaseExpiration section[:StorageLeaseExpiration].strftime('%Y-%m-%dT%H:%M:%S%z')
                      end
                    }
                  end
                  if section = instantiation_params[:NetworkConfigSection]
                    NetworkConfigSection {
                      self['ovf'].Info 'Configuration parameters for logical networks'
                      if network_configs = section[:NetworkConfig]
                        network_configs = [network_configs] if network_configs.is_a?(Hash)
                        network_configs.each do |network_config|
                          NetworkConfig(:networkName => network_config[:networkName]) {
                            if configuration = network_config[:Configuration]
                              Configuration {
                                ParentNetwork(configuration[:ParentNetwork])
                                FenceMode configuration[:FenceMode]
                              }
                            end
                          }
                        end
                      end
                    }
                  end
                }
              end
              Source(:href => "#{end_point}vAppTemplate/#{vapp_template_id}")
              if options.key?(:IsSourceDelete)
                IsSourceDelete options[:IsSourceDelete]
              end
              if options.key?(:AllEULAsAccepted)
                AllEULAsAccepted options[:AllEULAsAccepted]
              end
            }
          end.to_xml

          begin
            request(
              :body    => body,
              :expects => 201,
              :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml'},
              :method  => 'POST',
              :parser  => Fog::ToHashDocument.new,
              :path    => "vdc/#{id}/action/instantiateVAppTemplate"
            )
          rescue Fog::Compute::VcloudDirector::BadRequest => e
            if e.minor_error_code == 'DUPLICATE_NAME'
              raise Fog::Compute::VcloudDirector::DuplicateName.new(e.message)
            end
            raise
          end
        end
      end

      class Mock

        def post_instantiate_vapp_template(vdc_id, vapp_template_id, name, options={})
          unless data[:vdcs][vdc_id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"(com.vmware.vcloud.entity.vdc:#{vdc_id})\"."
            )
          end

          type = 'vApp'
          vapp_id = "vapp-#{uuid}"
          vm_id = "vm-#{uuid}"

          data[:vapps][vapp_id] = {
            :name => name,
            :vdc_id => vdc_id,
            :description => options.fetch(:description, "vApp created from #{vapp_template_id}"),
            :networks => [],
            :metadata => {:'vapp_key' => 'vapp_value'},
            :status => "0",
          }

          data[:vms][vm_id] = {
            :name => 'vm-template-name',
            :parent_vapp => vapp_id,
            :memory_in_mb => "1024",
            :cpu_count => "2",
            :metadata => {:'vm_key' => 'vm_value'},
            :nics => [
              {
              :network_name => 'Default Network',
              :mac_address => "00:50:56:00:00:00",
              :ip_address => "192.168.0.1",
              }
            ],
          }

          owner = {
            :href => make_href("#{type}/#{vapp_id}"),
            :type => "application/vnd.vmware.vcloud.#{type}+xml"
          }
          task_id = enqueue_task(
            "Creating Virtual Application #{name}(#{vapp_id})", 'vdcInstantiateVapp', owner,
            :on_success => lambda do
              data[:vapps][vapp_id][:status] = "8"
            end
          )

          body = get_vapp(vapp_id).body

          body[:Tasks] = {
            :Task => task_body(task_id)
          }

          Excon::Response.new(
            :status => 201,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end

      end
    end
  end
end
