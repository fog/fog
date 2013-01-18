module Fog
  module DNS
    class AWS
      class Real

        require 'fog/aws/parsers/dns/get_change'

        # returns the current state of a change request
        #
        # ==== Parameters
        # * change_id<~String>
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'Id'<~String>
        #     * 'Status'<~String>
        #     * 'SubmittedAt'<~String>
        #   * status<~Integer> - 200 when successful
        def get_change(change_id)

          # AWS methods return change_ids that looks like '/change/id'.  Let the caller either use
          # that form or just the actual id (which is what this request needs)
          change_id = change_id.sub('/change/', '')

          request({
            :expects => 200,
            :parser  => Fog::Parsers::DNS::AWS::GetChange.new,
            :method  => 'GET',
            :path    => "change/#{change_id}"
          })

        end

      end
    end
  end
end
