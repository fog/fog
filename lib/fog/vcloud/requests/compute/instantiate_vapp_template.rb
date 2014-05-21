module Fog
  module Vcloud
    class Compute
      module Shared
        private

        def validate_instantiate_vapp_template_options options
          # :network_uri removed, if not specified will use template network config.
          valid_opts = [:catalog_item_uri, :name, :vdc_uri]
          unless valid_opts.all? { |opt| options.key?(opt) }
            raise ArgumentError.new("Required data missing: #{(valid_opts - options.keys).map(&:inspect).join(", ")}")
          end

          catalog_item_uri = options[:catalog_item_uri]

          # Figure out the template_uri
          catalog_item = get_catalog_item( catalog_item_uri ).body
          catalog_item[:Entity] = [ catalog_item[:Entity] ] if catalog_item[:Entity].is_a?(Hash)
          catalog_item[:Link] = [ catalog_item[:Link] ] if catalog_item[:Link].is_a?(Hash)

          options[:template_uri] = begin
             catalog_item[:Entity].find { |entity| entity[:type] == "application/vnd.vmware.vcloud.vAppTemplate+xml" }[:href]
          rescue
            raise RuntimeError.new("Unable to locate template uri for #{catalog_item_uri}")
          end

          customization_options = begin
              get_vapp_template(options[:template_uri]).body[:Children][:Vm][:GuestCustomizationSection]
          rescue
            raise RuntimeError.new("Unable to get customization options for #{catalog_item_uri}")
          end

          # Check to see if we can set the password
          if options[:password] and customization_options[:AdminPasswordEnabled] == "false"
            raise ArgumentError.new("This catalog item (#{catalog_item_uri}) does not allow setting a password.")
          end

          # According to the docs if CustomizePassword is "true" then we NEED to set a password
          if customization_options[:AdminPasswordEnabled] == "true" and customization_options[:AdminPasswordAuto] == "false" and ( options[:password].nil? or options[:password].empty? )
            raise ArgumentError.new("This catalog item (#{catalog_item_uri}) requires a :password to instantiate.")
          end
        end

        def generate_instantiate_vapp_template_request(options)
          xml = Builder::XmlMarkup.new
          xml.InstantiateVAppTemplateParams(xmlns.merge!(:name => options[:name], :"xml:lang" => "en")) {
            xml.Description(options[:description])
            xml.InstantiationParams {
              if options[:network_uri]
                # TODO - implement properly
                xml.NetworkConfigSection {
                  xml.tag!("ovf:Info"){ "Configuration parameters for logical networks" }
                  xml.NetworkConfig("networkName" => options[:network_name]) {
                    # xml.NetworkAssociation( :href => options[:network_uri] )
                      xml.Configuration {
                        xml.ParentNetwork("name" => options[:network_name], "href" => options[:network_uri])
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
      end

      class Real
        include Shared

        def instantiate_vapp_template options = {}
          validate_instantiate_vapp_template_options options
          request(
            :body     => generate_instantiate_vapp_template_request(options),
            :expects  => 201,
            :headers  => {'Content-Type' => 'application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml'},
            :method   => 'POST',
            :uri      => options[:vdc_uri] + '/action/instantiateVAppTemplate',
            :parse    => true
          )
        end
      end
    end
  end
end
