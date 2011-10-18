module Fog
  module DNS
    class AWS
      class Real

        require 'fog/aws/parsers/dns/create_hosted_zone'

        # Creates a new hosted zone
        #
        # ==== Parameters
        # * name<~String> - The name of the domain. Must be a fully-specified domain that ends with a period
        # * options<~Hash>
        #   * caller_ref<~String> - unique string that identifies the request & allows failed
        #                           calls to be retried without the risk of executing the operation twice
        #   * comment<~Integer> -
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'HostedZone'<~Hash>:
        #       * 'Id'<~String> -
        #       * 'Name'<~String> -
        #       * 'CallerReference'<~String>
        #       * 'Comment'<~String> -
        #     * 'ChangeInfo'<~Hash> -
        #       * 'Id'<~String>
        #       * 'Status'<~String>
        #       * 'SubmittedAt'<~String>
        #     * 'NameServers'<~Array>
        #       * 'NameServer'<~String>
        #   * status<~Integer> - 201 when successful
        def create_hosted_zone(name, options = {})

          optional_tags = ''
          if options[:caller_ref]
              optional_tags+= "<CallerReference>#{options[:caller_ref]}</CallerReference>"
          else
            #make sure we have a unique call reference
            caller_ref = "ref-#{rand(1000000).to_s}"
            optional_tags+= "<CallerReference>#{caller_ref}</CallerReference>"
          end
          if options[:comment]
              optional_tags+= "<HostedZoneConfig><Comment>#{options[:comment]}</Comment></HostedZoneConfig>"
          end

          request({
            :body       => %Q{<?xml version="1.0" encoding="UTF-8"?><CreateHostedZoneRequest xmlns="https://route53.amazonaws.com/doc/2010-10-01/"><Name>#{name}</Name>#{optional_tags}</CreateHostedZoneRequest>},
            :parser     => Fog::Parsers::DNS::AWS::CreateHostedZone.new,
            :expects    => 201,
            :method     => 'POST',
            :path       => "hostedzone"
          })

        end

      end
    end
  end
end
