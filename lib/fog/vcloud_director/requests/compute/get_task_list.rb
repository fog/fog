module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :get_tasks_list, :get_task_list

        # Retrieve a list of this organization's queued, running, or recently
        # completed tasks.
        #
        # @param [String] id Object identifier of the organization.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-TaskList.html
        # @since vCloud API version 0.9
        def get_task_list(id)
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "tasksList/#{id}"
          )
          ensure_list! response.body, :Task
          response
        end
      end

      class Mock
        def get_task_list(id)
          unless id == data[:org][:uuid]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"com.vmware.vcloud.entity.org:#{id}\"."
            )
          end

          body =
            {:xmlns=>xmlns,
             :xmlns_xsi=>xmlns_xsi,
             :name=>"Tasks Lists",
             :type=>"application/vnd.vmware.vcloud.tasksList+xml",
             :href=>make_href("tasksList/#{id}"),
             :xsi_schemaLocation=>xsi_schema_location}

          tasks = data[:tasks].map do |task_id, task|
            {:status => task[:status],
             :startTime => task[:startTime].iso8601,
             :operationName => task[:operationName],
             :operation => task[:operation],
             :expiryTime => task[:expiryTime].utc.iso8601,
             :endTime => task[:endTime].iso8601,
             :cancelRequested => task[:cancelRequested].to_s,
             :name => task[:name],
             :id => "urn:vcloud:task:#{id}",
             :type => 'application/vnd.vmware.vcloud.task+xml',
             :href => make_href("task/#{task_id}"),
             :Owner =>
              {:type => "application/vnd.vmware.vcloud.vApp+xml",
               :name => "vApp_#{user_name}_0",
               :href=> make_href("vApp/vapp-#{uuid}")},
             :User =>
              {:type => "application/vnd.vmware.admin.user+xml",
               :name => user_name,
               :href => make_href("admin/user/#{user_uuid}")},
             :Organization =>
              {:type => "application/vnd.vmware.vcloud.org+xml",
               :name => org_name,
               :href => make_href("org/#{org_uuid}")},
             :Progress => task[:Progress].to_s,
             :Details => task[:Details] || ''}
          end
          tasks = tasks.first if tasks.size == 1
          body[:Task] = tasks

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end
      end
    end
  end
end
