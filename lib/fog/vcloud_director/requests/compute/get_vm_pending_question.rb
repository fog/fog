module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a question being asked by a VM.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #     * :href<~String> - The URI of the entity.
        #     * :type<~String> - The MIME type of the entity.
        #     * :Question<~String> - Question text.
        #     * :QuestionId<~String> - Question ID of this question.
        #     * Choices<~Array<Hash>>:
        #       * Id<~String> - Choice ID of the answer.
        #       * Text<~String> - Answer text.
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VmPendingQuestion.html
        # @since vCloud API version 0.9
        def get_vm_pending_question(id)
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/question"
          )
          ensure_list! response.body, :Choices
          response
        end
      end
    end
  end
end
