module Fog
  module Compute
    class VcloudDirector
      class Real
        
        #TODO move all the logic to a generator
        
        def instantiate_vapp_template(vapp_name, template_id, options = {})
          params = populate_uris(options.merge(:vapp_name => vapp_name, :template_id => template_id))
          validate_uris(params)
          
          data = generate_instantiate_vapp_template_request(params)
          
          request(
            :body => data,
            :expects => 201,
            :headers => { 'Content-Type' => 'application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml' },
            :method => 'POST',
            :parser => Fog::ToHashDocument.new,
            :path => "vdc/#{params[:vdc_id]}/action/instantiateVAppTemplate"
          )
        end
        
        def validate_uris(options ={})
          [:vdc_uri, :network_uri].each do |opt_uri|
            result = default_organization_body[:Link].detect {|org| org[:href] == options[opt_uri]}
            raise("#{opt_uri}: #{options[opt_uri]} not found") unless result
          end
        end
        
        def populate_uris(options = {})
          options[:vdc_id] ||= default_vdc_id
          options[:vdc_uri] =  vdc_end_point(options[:vdc_id])
          options[:network_id] ||= default_network_id
          options[:network_uri] = network_end_point(options[:network_id])
          #options[:network_name] = default_network_name || raise("error retrieving network name")
          options[:template_uri] = vapp_template_end_point(options[:template_id]) || raise(":template_id option is required")
          #customization_options = get_vapp_template(options[:template_uri]).body[:Children][:Vm][:GuestCustomizationSection]
          ## Check to see if we can set the password
          #if options[:password] and customization_options[:AdminPasswordEnabled] == "false"
          #  raise "The catalog item #{options[:catalog_item_uri]} does not allow setting a password."
          #end
          #
          ## According to the docs if CustomizePassword is "true" then we NEED to set a password
          #if customization_options[:AdminPasswordEnabled] == "true" and customization_options[:AdminPasswordAuto] == "false" and ( options[:password].nil? or options[:password].empty? )
          #  raise "The catalog item #{options[:catalog_item_uri]} requires a :password to instantiate."
          #end
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
            xml.AllEULAsAccepted("true")
          }
        end
        
        
        def xmlns
            { 'xmlns' => "http://www.vmware.com/vcloud/v1.5",
              "xmlns:ovf" => "http://schemas.dmtf.org/ovf/envelope/1",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
              "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema" 
            }
        end
        
#        def validate_instantiate_vapp_template_options options
#          # :network_uri removed, if not specified will use template network config.
#          valid_opts = [:catalog_item_uri, :name, :vdc_uri]
#          unless valid_opts.all? { |opt| options.has_key?(opt) }
#            raise ArgumentError.new("Required data missing: #{(valid_opts - options.keys).map(&:inspect).join(", ")}")
#          end
#
#          catalog_item_uri = options[:catalog_item_uri]
#
#          # Figure out the template_uri
#          catalog_item = get_catalog_item( catalog_item_uri ).body
#          catalog_item[:Entity] = [ catalog_item[:Entity] ] if catalog_item[:Entity].is_a?(Hash)
#          catalog_item[:Link] = [ catalog_item[:Link] ] if catalog_item[:Link].is_a?(Hash)
#
#          options[:template_uri] = begin
#             catalog_item[:Entity].detect { |entity| entity[:type] == "application/vnd.vmware.vcloud.vAppTemplate+xml" }[:href]
#          rescue
#            raise RuntimeError.new("Unable to locate template uri for #{catalog_item_uri}")
#          end
#
#          customization_options = begin
#              get_vapp_template(options[:template_uri]).body[:Children][:Vm][:GuestCustomizationSection]
#          rescue
#            raise RuntimeError.new("Unable to get customization options for #{catalog_item_uri}")
#          end
#
#          # Check to see if we can set the password
#          if options[:password] and customization_options[:AdminPasswordEnabled] == "false"
#            raise ArgumentError.new("This catalog item (#{catalog_item_uri}) does not allow setting a password.")
#          end
#
#          # According to the docs if CustomizePassword is "true" then we NEED to set a password
#          if customization_options[:AdminPasswordEnabled] == "true" and customization_options[:AdminPasswordAuto] == "false" and ( options[:password].nil? or options[:password].empty? )
#            raise ArgumentError.new("This catalog item (#{catalog_item_uri}) requires a :password to instantiate.")
#          end
#        end

      end
    end
  end
end
