require 'fog/vcloudng'
require 'fog/compute'

class String
  def to_bool
    return true   if self == true   || self =~ (/(true|t|yes|y|1)$/i)
    return false  if self == false  || self.empty? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end


class VcloudngParser < Fog::Parsers::Base

  def extract_attributes(attributes_xml)
    attributes = {}
    until attributes_xml.empty?
      if attributes_xml.first.is_a?(Array)
        until attributes_xml.first.empty?
          attribute = attributes_xml.first.shift
          attributes[attribute.localname] = attribute.value
        end
      else
        attribute = attributes_xml.shift
        attributes[attribute.localname] = attribute.value
      end
    end
    attributes
  end
end


module Fog
  module Compute
    class Vcloudng < Fog::Service
   
     module Defaults
       PATH   = '/api'
       PORT   = 443
       SCHEME = 'https'
     end
     
     requires :vcloudng_username, :vcloudng_password, :vcloudng_host
     
     secrets :vcloudng_password
     
     model_path 'fog/vcloudng/models/compute'
     model       :organization
     collection  :organizations
     model       :catalog
     collection  :catalogs
     model       :catalog_item
     collection  :catalog_items
     model       :vdc
     collection  :vdcs
     
     request_path 'fog/vcloudng/requests/compute'
     request :get_organizations
     request :get_organization
     request :get_catalog
     request :get_catalog_item
     request :get_vdc
     request :get_vapp_template
     request :instantiate_vapp_template
     
     

     class Real
       attr_reader :end_point

        def initialize(options={})
          @vcloudng_password = options[:vcloudng_password]
          @vcloudng_username = options[:vcloudng_username]
          @connection_options = options[:connection_options] || {}
          @host       = options[:vcloudng_host]
          @path       = options[:path]        || Fog::Compute::Vcloudng::Defaults::PATH
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || Fog::Compute::Vcloudng::Defaults::PORT
          @scheme     = options[:scheme]      || Fog::Compute::Vcloudng::Defaults::SCHEME
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
          @end_point = "#{@scheme}://#{@host}#{@path}/"
        end

        def auth_token
          response = @connection.request({
            :expects   => 200,
            :headers   => { 'Authorization' => "Basic #{Base64.encode64("#{@vcloudng_username}:#{@vcloudng_password}").delete("\r\n")}",
                            'Accept' => 'application/*+xml;version=1.5'
                          },
            :host      => @host,
            :method    => 'POST',
            :parser    => Fog::Parsers::Compute::Vcloudng::GetOrganizations.new,
            :path      => "/api/sessions"  # curl http://example.com/api/versions | grep LoginUrl
          })
          response.headers['Set-Cookie']
        end
        

        def reload
          @cookie = nil # verify that this makes the connection to be restored, if so use Excon::Errors::Forbidden instead of Excon::Errors::Unauthorized
          @connection.reset
        end

        def request(params)
          unless @cookie
            @cookie = auth_token
          end
          begin
            do_request(params)
            # this is to know if Excon::Errors::Unauthorized really happens
          #rescue Excon::Errors::Unauthorized
          #  @cookie = auth_token
          #  do_request(params)
          end
        end

        def do_request(params)
          headers = {}
          if @cookie
            headers.merge!('Cookie' => @cookie)
          end
          if params[:path]
              if params[:override_path] == true
                  path = params[:path]
              else
                  path = "#{@path}/#{params[:path]}"
              end
          else
              path = "#{@path}"
          end
          @connection.request({
            :body     => params[:body],
            :expects  => params[:expects],
            :headers  => headers.merge!(params[:headers] || {}),
            :host     => @host,
            :method   => params[:method],
            :parser   => params[:parser],
            :path     => path
          })
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
        
        def default_organization_id
          @default_organization_id ||= begin
            org_list = get_organizations.body['OrgList']
            if org_list.length == 1
              org_list.first['href'].split('/').last
            else
              nil
            end
          end
        end

        def default_organization_body
          return nil unless default_organization_id
          @default_organization_body ||= begin
          response = get_organization(default_organization_id)
          return nil unless response.respond_to? 'data'
          response.data[:body]
          end
        end

     end


     class Mock
     end

   end
  end
end


