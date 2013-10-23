module Fog
  module Compute
    class VcloudDirector
      class Real
        # Delete a media object.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the media object.
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
        #     * :href<~String> - Contains the URI to the entity.
        #     * :name<~String> - Contains the name of the entity.
        #     * :type<~String> - Contains the type of the entity.
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
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/DELETE-Media.html
        # @since vCloud API version 0.9
        def delete_media(id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :parser  => Fog::ToHashDocument.new,
            :path    => "media/#{id}"
          )
        end
      end

      class Mock
        def delete_media(id)
          unless media = data[:medias][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"(com.vmware.vcloud.entity.media:#{id})\""
            )
          end

          owner = {
            :href => make_href("media/#{id}"),
            :type => 'application/vnd.vmware.vcloud.media+xml'
          }
          task_id = enqueue_task(
            "Deleting Media File(#{media[:file][:uuid]})", 'vdcDeleteMedia', owner,
            :on_success => lambda do
              data[:medias].delete(id)
            end
          )
          body = {
            :xmlns => xmlns,
            :xmlns_xsi => xmlns_xsi,
            :xsi_schemaLocation => xsi_schema_location,
          }.merge(task_body(task_id))

          Excon::Response.new(
            :status => 202,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end
      end
    end
  end
end
