require 'fog/vcloud_director'
require 'fog/compute'
require 'fog/vcloud_director/requests/compute/helper'

class VcloudDirectorParser < Fog::Parsers::Base

  def extract_attributes(attributes_xml)
    attributes = {}
    until attributes_xml.empty?
      if attributes_xml.first.is_a?(Array)
        until attributes_xml.first.empty?
          attribute = attributes_xml.first.shift
          attributes[attribute.localname.to_sym] = attribute.value
        end
      else
        attribute = attributes_xml.shift
        attributes[attribute.localname.to_sym] = attribute.value
      end
    end
    attributes
  end
  

end

class NonLoaded
end

module Fog
  module Compute
    class VcloudDirector < Fog::Service
   
     module Defaults
       PATH   = '/api'
       PORT   = 443
       SCHEME = 'https'
       API_VERSION = '5.1'
     end
     
     module Errors
       class ServiceError < Fog::Errors::Error; end
       class Task < ServiceError; end
     end
       
     
     requires :vcloud_director_username, :vcloud_director_password, :vcloud_director_host
     recognizes :vcloud_director_api_version
     
     secrets :vcloud_director_password
     
     
     model_path 'fog/vcloud_director/models/compute'
     model       :catalog
     collection  :catalogs
     model       :organization
     collection  :organizations
     model       :catalog_item
     collection  :catalog_items
     model       :vdc
     collection  :vdcs
     model       :vapp
     collection  :vapps
     model       :task
     collection  :tasks
     model       :vm
     collection  :vms
     model       :vm_customization
     collection  :vm_customizations
     model       :network
     collection  :networks
     model       :disk
     collection  :disks
     model       :vm_network
     collection  :vm_networks
     model       :tag # this is called metadata in vcloud
     collection  :tags

     
     request_path 'fog/vcloud_director/requests/compute'
     request :get_organizations
     request :get_organization
     request :get_catalog
     request :get_catalog_item
     request :get_vdc
     request :get_vapp_template
     request :get_vapp
     request :get_vms
     request :instantiate_vapp_template
     request :get_task
     request :get_tasks_list
     request :get_vm_customization
     request :put_vm_customization
     request :get_network
     request :get_vm_cpu
     request :put_vm_cpu
     request :get_vm_memory
     request :put_vm_memory
     request :get_vm_disks
     request :put_vm_disks
     request :get_vm_network
     request :put_vm_network
     request :get_metadata
     request :post_vm_metadata
     request :put_metadata_value
     request :delete_metadata
     request :post_vm_poweron
     request :get_request # this is used for manual testing
     request :get_href    # this is used for manual testing
     request :get_vms_by_metadata
     request :get_vm
     request :post_task_cancel

     class Model < Fog::Model
       def initialize(attrs={})
         super(attrs)
         lazy_load_attrs.each do |attr|
           attributes[attr]= NonLoaded if attributes[attr].nil? 
           make_lazy_load_method(attr)
         end
         self.class.attributes.each{|attr| make_attr_loaded_method(attr) }
       end
       
       def lazy_load_attrs
         @lazy_load_attrs ||= self.class.attributes - attributes.keys
       end
        
       def make_lazy_load_method(attr)
         self.class.instance_eval do 
           define_method(attr) do
             reload if attributes[attr] == NonLoaded and !@inspecting
             attributes[attr]
           end
         end
       end
       
       # it adds an attr_loaded? method to know if the value has been loaded yet or not: ie description_loaded?
       def make_attr_loaded_method(attr)
         self.class.instance_eval do 
           define_method("#{attr}_loaded?") do
             attributes[attr] != NonLoaded
           end
         end
       end
        
       def inspect
         @inspecting = true
         out = super
         @inspecting = false
         out
       end
     end
     
     class Collection < Fog::Collection
       def all(lazy_load=true)
         lazy_load ? index : get_everyone
       end
       
       def get(item_id)
         item = get_by_id(item_id)
         return nil unless item
         new(item)
       end
       
       def get_by_name(item_name)
         item_found = item_list.detect{|item| item[:name] == item_name }
         return nil unless item_found
         get(item_found[:id])
       end
        
       def index
         load(item_list)
       end 
        
       def get_everyone
         items = item_list.map {|item| get_by_id(item[:id]) }
         load(items) 
       end
     end

     class Real
       include Fog::Compute::Helper
       
       attr_reader :end_point, :api_version

       def initialize(options={})
         @vcloud_director_password = options[:vcloud_director_password]
         @vcloud_director_username = options[:vcloud_director_username]
         @connection_options = options[:connection_options] || {}
         @host       = options[:vcloud_director_host]
         @path       = options[:path]        || Fog::Compute::VcloudDirector::Defaults::PATH
         @persistent = options[:persistent]  || false
         @port       = options[:port]        || Fog::Compute::VcloudDirector::Defaults::PORT
         @scheme     = options[:scheme]      || Fog::Compute::VcloudDirector::Defaults::SCHEME
         @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
         @end_point = "#{@scheme}://#{@host}#{@path}/"
         @api_version = options[:vcloud_director_api_version] || Fog::Compute::VcloudDirector::Defaults::API_VERSION
       end
         
       def auth_token
         response = @connection.request({
           :expects   => 200,
           :headers   => { 'Authorization' => "Basic #{Base64.encode64("#{@vcloud_director_username}:#{@vcloud_director_password}").delete("\r\n")}",
                           'Accept' => 'application/*+xml;version=' +  @api_version
                         },
           :host      => @host,
           :method    => 'POST',
           :parser    => Fog::ToHashDocument.new,
           :path      => "/api/sessions"  # curl http://example.com/api/versions | grep LoginUrl
         })
         response.headers['Set-Cookie'] || response.headers['set-cookie']
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
         headers = { 'Accept' => 'application/*+xml;version=' +  @api_version }
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
       rescue => @e
         raise @e unless @e.class.to_s =~ /^Excon::Errors/
         if @e.respond_to?(:response)
           puts @e.response.status
           puts CGI::unescapeHTML(@e.response.body)
         end
         raise @e
       end
       
       def process_task(response_body)
         task = make_task_object(response_body)
         wait_and_raise_unless_success(task)
         true
       end
       
       def make_task_object(task_response)
         task_response[:id] = task_response[:href].split('/').last
         tasks.new(task_response)
       end
        
       def wait_and_raise_unless_success(task)
         task.wait_for { non_running? }
         raise Errors::Task.new "status: #{task.status}, error: #{task.error}" unless task.success?
       end
       
       def add_id_from_href!(data={})         
         data[:id] = data[:href].split('/').last
       end
       
     end


     class Mock
     end

   end
  end
end


