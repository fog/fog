require 'date'

module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a task.
        #
        # @param [String] id The object identifier of the task.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #     * :href<~String> - The URI of the entity.
        #     * :type<~String> - The MIME type of the entity.
        #     * :id<~String> - The entity identifier, expressed in URN format.
        #       The value of this attribute uniquely identifies the entity,
        #       persists for the life of the entity, and is never reused.
        #     * :operationKey<~String> - Optional unique identifier to support
        #       idempotent semantics for create and delete operations.
        #     * :name<~String> - The name of the entity.
        #     * :cancelRequested<~String> - Whether user has requested this
        #       processing to be canceled.
        #     * :endTime<~String> - The date and time that processing of the
        #       task was completed. May not be present if the task is still
        #       being executed.
        #     * :expiryTime<~String> - The date and time at which the task
        #       resource will be destroyed and no longer available for
        #       retrieval. May not be present if the task has not been executed
        #       or is still being executed.
        #     * :operation<~String> - A message describing the operation that
        #       is tracked by this task.
        #     * :operationName<~String> - The short name of the operation that
        #       is tracked by this task.
        #     * :serviceNamespace<~String> - Identifier of the service that
        #       created the task.
        #     * :startTime<~String> - The date and time the system started
        #       executing the task. May not be present if the task has not been
        #       executed yet.
        #     * :status<~String> - The execution status of the task.
        #     * :Link<~Array<Hash>>:
        #     * :Description<~String> - Optional description.
        #     * :Owner<~Hash> - Reference to the owner of the task. This is
        #       typically the object that the task is creating or updating.
        #       * :href<~String> - Contains the URI to the entity.
        #       * :name<~String> - Contains the name of the entity.
        #       * :type<~String> - Contains the type of the entity.
        #     * :Error<~Hash> - Represents error information from a failed
        #       task.
        #       * :majorErrorCode<~String> - The class of the error. Matches
        #         the HTTP status code.
        #       * :message<~String> - An one line, human-readable message
        #         describing the error that occurred.
        #       * :minorErrorCode<~String> - Resource-specific error code.
        #       * :stackTrace<~String> - The stack trace of the exception.
        #       * :vendorSpecificErrorCode<~String> - A vendor- or
        #         implementation-specific error code that can reference
        #         specific modules or source lines for diagnostic purposes.
        #     * :User<~Hash> - The user who started the task.
        #       * :href<~String> - Contains the URI to the entity.
        #       * :name<~String> - Contains the name of the entity.
        #       * :type<~String> - Contains the type of the entity.
        #     * :Organization<~Hash> - The organization to which the :User
        #       belongs.
        #       * :href<~String> - Contains the URI to the entity.
        #       * :name<~String> - Contains the name of the entity.
        #       * :type<~String> - Contains the type of the entity.
        #     * :Progress<~String> - Read-only indicator of task progress as an
        #       approximate percentage between 0 and 100. Not available for all
        #       tasks.
        #     * :Params
        #     * :Details<~String> - Detailed message about the task. Also
        #       contained by the :Owner entity when task status is preRunning.
        #
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Task.html
        # @since vCloud API version 0.9
        def get_task(id)
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "task/#{id}"
          )

          # vCloud Director bug: Owner may be absent for some tasks, fix
          # targeted for 5.1.3 (due out at the beginning Q1 2014).
          #
          # We'd prefer that Owner is always present; if nothing else, this
          # let's the tests pass.
          response.body[:Owner] ||= {:href => '', :name => nil, :type => nil}

          response
        end
      end

      class Mock
        def get_task(id)
          unless data[:tasks][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          body = {
            :xmlns => xmlns,
            :xmlns_xsi => xmlns_xsi,
            :xsi_schemaLocation => xsi_schema_location
          }.merge(task_body(id))

          Excon::Response.new(
            :status => 200,
            :headers => {'Type' => "application/#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end

        private

        # @param [String] id Object identifier of the task.
        # @return [Hash]
        def task_body(id)
          task = data[:tasks][id]

          body = {
            :href => make_href("tasks/#{id}"),
            :type => 'application/vnd.vmware.vcloud.task+xml',
            :id => "urn:vcloud:tasl:#{id}",
            :name => task[:name],
            :cancelRequested => task[:cancel_requested].to_s,
            :expiryTime => task[:expiry_time].strftime('%Y-%m-%dT%H:%M:%S%z'),
            :operation => task[:operation],
            :operationName => task[:operation_name],
            :serviceNamespace => task[:service_namespace],
            :status => task[:status],
            :Link => [],
            :Owner => task[:owner],
            :User => { # for now, always the current user
              :href => make_href("admin/user/#{user_uuid}"),
              :name => user_name,
              :type => 'application/vnd.vmware.admin.user+xml',
            },
            :Organization => { # for now, always the current org
              :href => make_href("org/#{data[:org][:uuid]}"),
              :name => data[:org][:name],
              :type => 'application/vnd.vmware.vcloud.org+xml',
            },
            :Progress => task[:progress].to_s,
            :Details => task[:details] || '',
          }
          body[:endTime] = task[:end_time].strftime('%Y-%m-%dT%H:%M:%S%z') if task[:end_time]
          body[:startTime] = task[:start_time].strftime('%Y-%m-%dT%H:%M:%S%z') if task[:start_time]
          body[:Description] = task[:description] if task[:description]

          if task[:status] == 'running'
            body[:Link] << {
              :href => make_href("task/#{id}/action/cancel"),
              :type => 'application/vnd.vmware.vcloud.task+xml',
              :rel => 'cancel',
            }
          end

          body
        end
      end
    end
  end
end
