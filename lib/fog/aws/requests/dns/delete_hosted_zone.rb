module Fog
  module DNS
    class AWS
      class Real

        require 'fog/aws/parsers/dns/delete_hosted_zone'

        # Delete a hosted zone
        #
        # ==== Parameters
        # * zone_id<~String> -
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ChangeInfo'<~Hash> -
        #       * 'Id'<~String> The ID of the request
        #       * 'Status'<~String> The current state of the hosted zone
        #       * 'SubmittedAt'<~String> The date and time the change was made
        #   * status<~Integer> - 200 when successful
        def delete_hosted_zone(zone_id)

          # AWS methods return zone_ids that looks like '/hostedzone/id'.  Let the caller either use
          # that form or just the actual id (which is what this request needs)
          zone_id = zone_id.sub('/hostedzone/', '')

          request({
            :expects => 200,
            :parser  => Fog::Parsers::DNS::AWS::DeleteHostedZone.new,
            :method  => 'DELETE',
            :path    => "hostedzone/#{zone_id}"
          })

        end

      end

      class Mock

        require 'time'

        def delete_hosted_zone(zone_id)
          response = Excon::Response.new
          key = [zone_id, "/hostedzone/#{zone_id}"].find{|k| !self.data[:zones][k].nil?}
          if key
            change = {
              :id => Fog::AWS::Mock.change_id,
              :status => 'INSYNC',
              :submitted_at => Time.now.utc.iso8601
            }
            self.data[:changes][change[:id]] = change
            response.status = 200
            response.body = {
              'ChangeInfo' => {
                'Id' => change[:id],
                'Status' => change[:status],
                'SubmittedAt' => change[:submitted_at]
              }
            }
            self.data[:zones].delete(key)
            response
          else
            response.status = 404
            response.body = "<?xml version=\"1.0\"?><ErrorResponse xmlns=\"https://route53.amazonaws.com/doc/2012-02-29/\"><Error><Type>Sender</Type><Code>NoSuchHostedZone</Code><Message>The specified hosted zone does not exist.</Message></Error><RequestId>#{Fog::AWS::Mock.request_id}</RequestId></ErrorResponse>"
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
        end
      end

    end
  end
end
