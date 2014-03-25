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
        #     * :href<~String> - The URI of the entity.
        #     * :type<~String> - The MIME type of the entity.
        #     * :id<~String> - The entity identifier, expressed in URN format.
        #       The value of this attribute uniquely identifies the entity,
        #       persists for the life of the entity, and is never reused.
        #     * :name<~String> - The name of the entity.
        #     * :Task<~Array<Hash>>:
        #       * :href<~String> - The URI of the entity.
        #       * :type<~String> - The MIME type of the entity.
        #       * :id<~String> - The entity identifier, expressed in URN
        #         format. The value of this attribute uniquely identifies the
        #         entity, persists for the life of the entity, and is never
        #         reused.
        #       * :operationKey<~String> - Optional unique identifier to
        #         support idempotent semantics for create and delete
        #         operations.
        #       * :name<~String> - The name of the entity.
        #       * :cancelRequested<~String> - Whether user has requested this
        #         processing to be canceled.
        #       * :endTime<~String> - The date and time that processing of the
        #         task was completed. May not be present if the task is still
        #         being executed.
        #       * :expiryTime<~String> - The date and time at which the task
        #         resource will be destroyed and no longer available for
        #         retrieval. May not be present if the task has not been
        #         executed or is still being executed.
        #       * :operation<~String> - A message describing the operation that
        #         is tracked by this task.
        #       * :operationName<~String> - The short name of the operation
        #         that is tracked by this task.
        #       * :serviceNamespace<~String> - Identifier of the service that
        #         created the task.
        #       * :startTime<~String> - The date and time the system started
        #         executing the task. May not be present if the task has not
        #         been executed yet.
        #       * :status<~String> - The execution status of the task.
        #       * :Link<~Array<Hash>>:
        #       * :Description<~String> - Optional description.
        #       * :Owner<~Hash> - Reference to the owner of the task. This is
        #         typically the object that the task is creating or updating.
        #         * :href<~String> - Contains the URI to the entity.
        #         * :name<~String> - Contains the name of the entity.
        #         * :type<~String> - Contains the type of the entity.
        #       * :Error<~Hash> - Represents error information from a failed
        #         task.
        #         * :majorErrorCode<~String> - The class of the error.  Matches
        #           the HTTP status code.
        #         * :message<~String> - An one line, human-readable message
        #           describing the error that occurred.
        #         * :minorErrorCode<~String> - Resource-specific error code.
        #         * :stackTrace<~String> - The stack trace of the exception.
        #         * :vendorSpecificErrorCode<~String> - A vendor- or
        #           implementation-specific error code that can reference
        #           specific modules or source lines for diagnostic purposes.
        #       * :User<~Hash> - The user who started the task.
        #         * :href<~String> - Contains the URI to the entity.
        #         * :name<~String> - Contains the name of the entity.
        #         * :type<~String> - Contains the type of the entity.
        #       * :Organization<~Hash> - The organization to which the :User
        #         belongs.
        #         * :href<~String> - Contains the URI to the entity.
        #         * :name<~String> - Contains the name of the entity.
        #         * :type<~String> - Contains the type of the entity.
        #       * :Progress<~String> - Read-only indicator of task progress as
        #         an approximate percentage between 0 and 100. Not available
        #         for all tasks.
        #       * :Params
        #       * :Details<~String> - Detailed message about the task. Also
        #         contained by the :Owner entity when task status is
        #         preRunning.
        #
        # @raise [Fog::Compute::VcloudDirector::BadRequest]
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

          body = {
            :xmlns => xmlns,
            :xmlns_xsi => xmlns_xsi,
            :xsi_schemaLocation => xsi_schema_location,
            :href => make_href("tasksList/#{id}"),
            :type => "application/vnd.vmware.vcloud.tasksList+xml",
            :name => "Tasks Lists",
            :Task => data[:tasks].keys.map {|task_id| task_body(task_id)}
          }

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
