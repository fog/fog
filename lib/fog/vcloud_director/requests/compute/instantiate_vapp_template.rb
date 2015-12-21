module Fog
  module Compute
    class VcloudDirector
      class Real
        # Create a vApp from a vApp template.
        #
        # The response includes a Task element. You can monitor the task to to
        # track the creation of the vApp.
        #
        # @param [String] vapp_name
        # @param [String] template_id
        # @param [Hash] options
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-InstantiateVAppTemplate.html
        # @since vCloud API version 0.9
        def instantiate_vapp_template(vapp_name, template_id, options={})
          params = populate_uris(options.merge(:vapp_name => vapp_name, :template_id => template_id))

          # @todo Move all the logic to a generator.
          data = generate_instantiate_vapp_template_request(params)

          request(
            :body    => data,
            :expects => 201,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vdc/#{params[:vdc_id]}/action/instantiateVAppTemplate"
          )
        end

        private

        def populate_uris(options = {})
          options[:vdc_id] || raise("vdc_id option is required")
          options[:vdc_uri] =  vdc_end_point(options[:vdc_id])
          options[:network_uri] = network_end_point(options[:network_id]) if options[:network_id]
          options[:template_uri] = vapp_template_end_point(options[:template_id]) || raise("template_id option is required")
          options
        end

        def generate_instantiate_vapp_template_request(options ={})
          xml = Builder::XmlMarkup.new
          xml.InstantiateVAppTemplateParams(xmlns.merge!(:name => options[:vapp_name], :"xml:lang" => "en")) {
            xml.Description(options[:description])
            xml.InstantiationParams {
              # This options are fully ignored
              if options[:network_uri]
                xml.NetworkConfigSection {
                  xml.tag!("ovf:Info"){ "Configuration parameters for logical networks" }
                  xml.NetworkConfig("networkName" => options[:network_name]) {
                    xml.Configuration {
                      xml.ParentNetwork(:href => options[:network_uri])
                      xml.FenceMode("bridged")
                    }
                  }
                }
              end
            }
            # The template
            xml.Source(:href => options[:template_uri])
            # Use of sourceItems for configuring VM's during instantiation.
            # NOTE: Name and storage profile configuration supported so far.
            # http://pubs.vmware.com/vca/index.jsp?topic=%2Fcom.vmware.vcloud.api.doc_56%2FGUID-BF9B790D-512E-4EA1-99E8-6826D4B8E6DC.html
            (options[:vms_config] || []).each do |vm_config|
              next unless vm_config[:href]
              xml.SourcedItem {
                xml.Source(:href => vm_config[:href])
                xml.VmGeneralParams{
                  xml.Name(vm_config[:name]) if vm_config[:name]
                }
                if storage_href = vm_config[:storage_profile_href]
                  xml.StorageProfile(:href => storage_href)
                end
              }
            end
            xml.AllEULAsAccepted("true")
          }
        end

        def xmlns
          {
            'xmlns'     => "http://www.vmware.com/vcloud/v1.5",
            "xmlns:ovf" => "http://schemas.dmtf.org/ovf/envelope/1",
            "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
            "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema"
          }
        end

        def vdc_end_point(vdc_id = nil)
          end_point + ( vdc_id ? "vdc/#{vdc_id}" : "vdc" )
        end

        def network_end_point(network_id = nil)
          end_point + ( network_id ? "network/#{network_id}" : "network" )
        end

        def vapp_template_end_point(vapp_template_id = nil)
          end_point + ( vapp_template_id ? "vAppTemplate/#{vapp_template_id}" : "vAppTemplate" )
        end

        def endpoint
          end_point
        end
      end
      
      class Mock
        # Assume the template is a single VM with one network interface and one disk.
        def instantiate_vapp_template(vapp_name, template_id, options={})          
          unless data[:catalog_items].values.find {|i| i[:template_id] == template_id}
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'No such template.'
            )
          end
          unless vdc = data[:vdcs][options[:vdc_id]]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'No such VDC.'
            )
          end
          
          vapp_uuid = uuid
          vapp_id   = "vapp-#{vapp_uuid}"
          owner = {
            :href => make_href("vApp/#{vapp_id}"),
            :type => 'application/vnd.vmware.vcloud.vm+xml'
          }
          task_id = enqueue_task(
            "Creating Virtual Application #{vapp_name}(#{vapp_uuid})", 'vdcInstantiateVapp', owner,
            :on_success => lambda do
              # Add to the VDC
              data[:vapps][vapp_id] = {
                :name => vapp_name,
                :vdc_id => options[:vdc_id],
                :description => 'From Template',
                :networks => [
                  {:parent_id => default_network_uuid }
                ]
              }
              vm_id = "vm-#{uuid}"
              data[:vms][vm_id] = {
                :name => vapp_name,
                :parent_vapp => vapp_id,
                :nics => [
                  {
                    :network_name => 'Default Network',
                    :mac_address  => '7d:68:a2:a0:a4:f8',
                    :ip_address   => nil
                  }
                ]
              }
              data[:disks][uuid] = {
                :name => 'Hard Disk 1',
                :capacity => 10240,
                :parent_vm => vm_id
              }
            end
          )
          body = {
            :href => make_href("vApp/#{vapp_id}"),
            :Tasks => {
              :Task => {
                :xmlns => xmlns,
                :xmlns_xsi => xmlns_xsi,
                :xsi_schemaLocation => xsi_schema_location,
              }.merge(task_body(task_id))
            }
          }

          Excon::Response.new(
            :status => 202,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end
      end
    end
  end
end
