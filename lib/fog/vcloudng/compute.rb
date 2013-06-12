require_relative './shared'


module Fog
  module Vcloudng
   module Compute

     module Bin
     end

     module Defaults
       PATH   = '/api'
       PORT   = 443
       SCHEME = 'https'
     end

     extend Fog::Vcloudng::Shared

     def self.new(options={})
       # Fog::Logger.deprecation("Fog::Vcloudng::Compute is deprecated, to be replaced with Compute 1.0 someday/maybe [light_black](#{caller.first})[/]")

       unless @required
         shared_requires
         @required = true
       end

       check_shared_options(options)

       if Fog.mocking?
          Fog::Vcloudng::Compute::Mock.new(options)
       else
          Fog::Vcloudng::Compute::Real.new(options)
       end
     end

     class Real
       attr_reader :end_point
       
       include Fog::Vcloudng::Shared::Real
       include Fog::Vcloudng::Shared::Parser

        def initialize(options={})
          @vcloudng_password = options[:vcloudng_password]
          @vcloudng_username = options[:vcloudng_username]
          @connection_options = options[:connection_options] || {}
          @host       = options[:vcloudng_host]
          @path       = options[:path]        || Fog::Vcloudng::Compute::Defaults::PATH
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || Fog::Vcloudng::Compute::Defaults::PORT
          @scheme     = options[:scheme]      || Fog::Vcloudng::Compute::Defaults::SCHEME
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
          @end_point = "#{@scheme}://#{@host}#{@path}/"
        end

        def default_vdc_id
          if default_organization_id
            @default_vdc_id ||= begin
              vdcs = get_organization(default_organization_id).body['Links'].select {|link|
                link['type'] == 'application/vnd.vmware.vcloud.vdc+xml'
              }
              if vdcs.length == 1
                vdcs.first['href'].split('/').last
              else
                nil
              end
            end
          else
            nil
          end
        end
        
        def default_vdc_body
          return nil unless default_vdc_id
          @default_vdc_body ||= begin
          response = get_vdc(default_vdc_id)
          return nil unless response.respond_to? 'data'
          response.data[:body]
          end
        end
        
        def default_catalog_id
          retun nil unless default_organization_body
          catalogs = default_organization_body["Links"].select {|l| l["type"] =~ /vcloud.catalog/ }
          return nil unless catalogs.length == 1
          catalogs.first["href"].split('/').last
        end
        
        def get_network_name_by_network_id(network_id)
          return nil unless default_vdc_body
          return nil unless network = default_vdc_body['AvailableNetworks'].detect{|net| net["href"] =~ /#{network_id}/}
          network["name"]
        end

        def default_network_id
          if default_vdc_id
            @default_network_id ||= begin
              networks = default_vdc_body['AvailableNetworks']
              if networks.length == 1
                networks.first['href'].split('/').last
              else
                nil
              end
            end
          else
            nil
          end
        end
        
        def default_network_name
          if default_vdc_id
            @default_network_name ||= begin
              networks = default_vdc_body['AvailableNetworks']
              if networks.length == 1
                networks.first['name']
              else
                nil
              end
            end
          else
            nil
          end
        end
        


     end


     class Mock
       include Fog::Vcloudng::Shared::Mock
       include Fog::Vcloudng::Shared::Parser

       def initialize(option = {})
         super
         @base_url = Fog::Vcloudng::Compute::Defaults::SCHEME + "://" +
                     options[:vcloudng_host] +
                     Fog::Vcloudng::Compute::Defaults::PATH

         @vcloudng_username = options[:vcloudng_username]
       end

       def data
         self.class.data[@vcloudng_username]
       end

       def reset_data
         self.class.data.delete(@vcloudng_username)
       end

     end

   end
  end
end


