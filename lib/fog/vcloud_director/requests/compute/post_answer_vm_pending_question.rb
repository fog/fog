module Fog
  module Compute
    class VcloudDirector
      class Real
        # Answer a question being asked by a VM.
        #
        # @param [String] id Object identifier of the VM.
        # @param [Integer] choice_id Choice ID of this answer.
        # @param [String] question_id Question ID of the question.
        # @return [Excon::Response]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-AnswerVmPendingQuestion.html
        # @since vCloud API version 0.9
        def post_answer_pending_vm_question(id, choice_id, question_id)
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5'
            }
            VmAnswerQuestion(attrs) {
              ChoiceId choice_id
              QuestionId question_id
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 204, # this might be wrong
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.vmPendingAnswer+xml'},
            :method  => 'POST',
            :path    => "vApp/#{id}/quesiton/action/answer"
          )
        end
      end
    end
  end
end
