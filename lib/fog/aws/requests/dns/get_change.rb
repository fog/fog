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

      class Mock
        def get_change(change_id)
          response = Excon::Response.new
          # find the record with matching change_id
          # records = data[:zones].values.map{|z| z[:records].values.map{|r| r.values}}.flatten
          change = self.data[:changes][change_id]

          if change
            response.status = 200
            submitted_at = Time.parse(change[:submitted_at])
            response.body = {
              'Id' => change[:id],
              # set as insync after some time
              'Status' => (submitted_at + Fog::Mock.delay) < Time.now ? 'INSYNC' : change[:status],
              'SubmittedAt' => change[:submitted_at]
            }
            response
          else
            response.status = 404
            response.body = "<?xml version=\"1.0\"?><ErrorResponse xmlns=\"https://route53.amazonaws.com/doc/2012-02-29/\"><Error><Type>Sender</Type><Code>NoSuchChange</Code><Message>Could not find resource with ID: #{change_id}</Message></Error><RequestId>#{Fog::AWS::Mock.request_id}</RequestId></ErrorResponse>"
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
        end
      end
    end
  end
end
