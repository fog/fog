require File.expand_path(File.join(File.dirname(__FILE__), '..', 'ibm'))
require 'fog/compute'

module Fog
  module Compute
    class IBM < Fog::Service

      requires :ibm_username, :ibm_password
      recognizes :location

      model_path 'fog/ibm/models/compute'

      model :image
      collection :images
      model :server
      collection :servers
      model :address
      collection :addresses
      model :key
      collection :keys
      model :location
      collection :locations
      model :vlan
      collection :vlans

      request_path 'fog/ibm/requests/compute'

      request :list_images
      request :create_image
      request :clone_image
      request :delete_image
      request :get_image
      request :get_image_agreement
      request :get_image_manifest
      # request :get_image_swbundles
      # request :get_image_swbundle

      request :list_instances
      request :create_instance
      request :delete_instance
      request :modify_instance
      request :get_instance
      request :get_instance_logs
      # request :get_instance_swbundle

      request :get_request

      request :list_addresses
      request :list_address_offerings
      request :list_vlans
      request :create_address
      request :delete_address

      request :list_keys
      request :create_key
      request :delete_key
      request :modify_key
      request :get_key

      request :list_locations
      request :get_location

      class Real
        def initialize(options={})
          @connection = Fog::IBM::Connection.new(options[:ibm_username], options[:ibm_password])
        end

        private

        def request(options)
          begin
            @connection.request(options)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Compute::IBM::NotFound.slurp(error)
            else
              error
            end
          end
        end
      end

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :instances    => {},
              :images       => populate_images,
              :keys         => {},
              :locations    => populate_locations,
              :private_keys => {},
              :addresses    => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def data
          self.class.data[@ibm_username]
        end

        def reset_data
          self.class.data.delete(@ibm_username)
          @data = self.class.data[@ibm_username]
        end

        def initialize(options={})
          @ibm_username = options[:ibm_username]
          @ibm_password = options[:ibm_password]
          @data = self.class.data[@ibm_username]
        end

        def self.populate_images
          images = {}
          images["20010001"] = {
            "name"=>"SUSE Linux Enterprise Server 11 SP1 for x86",
            "manifest"=>"https://www-147.ibm.com/cloud/enterprise/ram.ws/RAMSecure/artifact/{6CD09CE4-E99B-D72F-6C29-233C9B2A1676}/1.0/parameters.xml",
            "state"=>1,
            "visibility"=>"PUBLIC",
            "owner"=>"SYSTEM",
            "platform"=>"SUSE Linux Enterprise Server/11 SP1",
            "location"=>"41",
            "createdTime"=>1282466781000,
            "supportedInstanceTypes"=>
            [{"detail"=>"Copper - 32 bit (vCPU: 1, RAM: 2 GiB, Disk: 60 GiB)",
               "label"=>"Copper 32 bit",
               "price"=>{"rate"=>0.095, "unitOfMeasure"=>"UHR  ", "countryCode"=>"897", "effectiveDate"=>-1, "currencyCode"=>"USD", "pricePerQuantity"=>1},
               "id"=>"COP32.1/2048/60"},
             {"detail"=>"Bronze - 32 bit (vCPU: 1, RAM: 2 GiB, Disk: 235 GiB)",
               "label"=>"Bronze 32 bit",
               "price"=>{"rate"=>0.115, "unitOfMeasure"=>"UHR  ", "countryCode"=>"897", "effectiveDate"=>-1, "currencyCode"=>"USD", "pricePerQuantity"=>1},
               "id"=>"BRZ32.1/2048/60*175"},
             {"detail"=>"Silver - 32 bit (vCPU: 2, RAM: 4 GiB, Disk: 410 GiB)",
               "label"=>"Silver 32 bit",
               "price"=>{"rate"=>0.2, "unitOfMeasure"=>"UHR  ", "countryCode"=>"897", "effectiveDate"=>-1, "currencyCode"=>"USD", "pricePerQuantity"=>1},
               "id"=>"SLV32.2/4096/60*350"},
             {"detail"=>"Gold - 32 bit (vCPU: 4, RAM: 4 GiB, Disk: 410 GiB)",
               "label"=>"Gold 32 bit",
               "price"=>{"rate"=>0.33, "unitOfMeasure"=>"UHR  ", "countryCode"=>"897", "effectiveDate"=>-1, "currencyCode"=>"USD", "pricePerQuantity"=>1},
               "id"=>"GLD32.4/4096/60*350"}],
            "productCodes"=>["rtpSr7dKs9ARDmuPy6WPgV"],
            "documentation"=>"https://www-147.ibm.com/cloud/enterprise/ram.ws/RAMSecure/artifact/{6CD09CE4-E99B-D72F-6C29-233C9B2A1676}/1.0/GettingStarted.html",
            "id"=>"20010001",
            "description"=>"Suse Linux 32 bit"
          }
          images
        end

        def self.populate_locations
          locations = {}
          locations["41"] = {
            "state"=>1,
            "location"=>"RTP",
            "capabilities"=>[
              {"entries"=>{"EXT3"=>["ext3"], "RAW"=>["raw"]}, "id"=>"oss.storage.format"},
              {"entries"=>{}, "id"=>"oss.instance.spec.i386"},
              {"entries"=>{}, "id"=>"oss.instance.spec.x86_64"},
              {"entries"=>{}, "id"=>"oss.storage.availabilityarea"}],
            "name"=>"Raleigh, U.S.A",
            "id"=>"41",
            "description"=>"This data center is located in Raleigh, North Carolina, U.S.A. The services provided are: Guest Instances, Image Capture, Persistent Storage, Reserved IP, Private VLAN/VPN."
          }
          locations["61"] = {
            "state"=>1,
            "location"=>"EHN",
            "capabilities"=>[
              {"entries"=>{"EXT3"=>["ext3"], "RAW"=>["raw"]}, "id"=>"oss.storage.format"},
              {"entries"=>{}, "id"=>"oss.instance.spec.i386"},
              {"entries"=>{}, "id"=>"oss.instance.spec.x86_64"},
              {"entries"=>{}, "id"=>"oss.storage.availabilityarea"}],
            "name"=>"Ehningen, Germany",
            "id"=>"61",
            "description"=>"This data center is located in Ehningen(near Baden-Wurttemberg), Germany. The services provided are: Guest Instances, Image Capture, Persistent Storage, Reserved IP, Private VLAN/VPN."
          }
          locations["82"] = {
            "state"=>1,
            "location"=>"us-co-dc1",
            "capabilities"=>[
              {"entries"=>{"EXT3"=>["ext3"], "RAW"=>["raw"]}, "id"=>"oss.storage.format"},
              {"entries"=>{}, "id"=>"oss.instance.spec.i386"},
              {"entries"=>{}, "id"=>"oss.instance.spec.x86_64"},
              {"entries"=>{}, "id"=>"oss.storage.availabilityarea"}],
            "name"=>"Boulder1, U.S.A",
            "id"=>"82",
            "description"=>"This data center is located in Boulder(near Denver), Colorado, U.S.A. The services provided are: Guest Instances, Image Capture, Persistent Storage, Reserved IP, Private VLAN/VPN."
          }
          locations["101"] = {
            "state"=>1,
            "location"=>"ca-on-dc1",
            "capabilities"=>[
              {"entries"=>{"EXT3"=>["ext3"], "RAW"=>["raw"]}, "id"=>"oss.storage.format"},
              {"entries"=>{}, "id"=>"oss.instance.spec.i386"},
              {"entries"=>{}, "id"=>"oss.instance.spec.x86_64"},
              {"entries"=>{}, "id"=>"oss.storage.availabilityarea"}],
            "name"=>"Markham, Canada",
            "id"=>"101",
            "description"=>"This data center is located in Markham(near Toronto), Ontario, Canada. The services provided are: Guest Instances, Image Capture, Persistent Storage, Reserved IP, Private VLAN/VPN."
          }
          locations["121"] = {
            "state"=>1,
            "location"=>"ap-jp-dc1",
            "capabilities"=>[
              {"entries"=>{"EXT3"=>["ext3"], "RAW"=>["raw"]}, "id"=>"oss.storage.format"},
              {"entries"=>{}, "id"=>"oss.instance.spec.i386"},
              {"entries"=>{}, "id"=>"oss.instance.spec.x86_64"},
              {"entries"=>{}, "id"=>"oss.storage.availabilityarea"}],
            "name"=>"Makuhari, Japan",
            "id"=>"121",
            "description"=>"This data center is located in Makuhari(near Tokoyo), Japan. The services provided are: Guest Instances, Image Capture, Persistent Storage, Reserved IP, Private VLAN/VPN."
          }
          locations["141"] = {
            "state"=>1,
            "location"=>"ap-sg-dc1",
            "capabilities"=>[
              {"entries"=>{"EXT3"=>["ext3"], "RAW"=>["raw"]}, "id"=>"oss.storage.format"},
              {"entries"=>{}, "id"=>"oss.instance.spec.i386"},
              {"entries"=>{}, "id"=>"oss.instance.spec.x86_64"},
              {"entries"=>{}, "id"=>"oss.storage.availabilityarea"}],
            "name"=>"Singapore, Singapore",
            "id"=>"141",
            "description"=>"This data center is located in Singapore. The services provided are: Guest Instances, Image Capture, Persistent Storage, Reserved IP, Private VLAN/VPN."
          }
          locations
        end

      end

    end
  end
end
