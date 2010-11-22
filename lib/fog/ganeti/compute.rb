module Fog
  module Ganeti
    class Compute < Fog::Service

      requires :password
      requires :host

      model_path 'fog/ganeti/models/compute'

      request_path 'fog/ganeti/requests/compute'
      request :cluster_features
      request :cluster_info
      request :cluster_redistribute_config
      request :cluster_tags_create
      request :cluster_tags_delete
      request :cluster_tags_list
      request :cluster_version

      request :instance_activate_disks
      request :instance_create
      request :instance_deactivate_disks
      request :instance_delete
      request :instance_export
      request :instance_info
      request :instance_list
      request :instance_migrate
      request :instance_modify
      request :instance_prepare_export
      request :instance_reboot
      request :instance_reinstall
      request :instance_rename
      request :instance_replace_disks
      request :instance_shutdown
      request :instance_startup
      request :instance_tags_create
      request :instance_tags_delete
      request :instance_tags_list
      request :instances_list

      request :job_delete
      request :job_list
      request :job_wait
      request :jobs_list

      request :node_evacuate
      request :node_list
      request :node_migrate
      request :node_role_create
      request :node_role_list
      request :node_storage_list
      request :node_storage_modify
      request :node_storage_repair
      request :node_tags_create
      request :node_tags_delete
      request :node_tags_list
      request :nodes_list
      request :oses_list

      class Mock
      end

      class Real

        def initialize(options={})
          require 'json'
          @ganeti_password = options[:password]
          @host            = options[:host]
          @port            = options[:port]   || 5080
          @scheme          = options[:scheme] || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", options[:persistent])
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:headers] ||= {}
          params[:headers].merge!({
            'Authorization' => "Basic #{Base64.encode64(@ganeti_password).delete("\r\n")}"
          })
          case params[:method]
          when 'DELETE', 'GET', 'HEAD'
            params[:headers]['Accept'] = 'application/json'
          when 'POST', 'PUT'
            params[:headers]['Content-Type'] = 'application/json'
          end

          response = @connection.request(params.merge!({:host => @host}))

          return response if response.body.empty?
          (response.body.chomp =~ %r{^\"(\d+)\"}m) ? $1 : JSON.parse(response.body)
        end

      end
    end
  end
end
