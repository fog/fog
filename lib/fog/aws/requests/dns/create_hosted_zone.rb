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
        #   * comment<~String> -
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
            optional_tags += "<CallerReference>#{options[:caller_ref]}</CallerReference>"
          else
            #make sure we have a unique call reference
            caller_ref = "ref-#{rand(1000000).to_s}"
            optional_tags += "<CallerReference>#{caller_ref}</CallerReference>"
          end
          if options[:comment]
            optional_tags += "<HostedZoneConfig><Comment>#{options[:comment]}</Comment></HostedZoneConfig>"
          end

          request({
            :body    => %Q{<?xml version="1.0" encoding="UTF-8"?><CreateHostedZoneRequest xmlns="https://route53.amazonaws.com/doc/#{@version}/"><Name>#{name}</Name>#{optional_tags}</CreateHostedZoneRequest>},
            :parser  => Fog::Parsers::DNS::AWS::CreateHostedZone.new,
            :expects => 201,
            :method  => 'POST',
            :path    => "hostedzone"
          })
        end
      end

      class Mock
        def create_hosted_zone(name, options = {})

          caller_ref = "ref-#{rand(1000000).to_s}"

          response = Excon::Response.new

          status = 201

          response.status = status

          response.body = {
            'HostedZone'  => { 'Id'              => '00000000000000',
                               'Name'            => name,
                               'CallerReference' => caller_ref },
            'ChangeInfo'  => { 'Id'              => '00000000000001',
                               'Status'          => status,
                               'SubmittedAt'     => Time.now.to_s },
            'NameServers' => [ '1.name.server.com', '2.name.server.com' ] }

          unless options[:comment].nil?
            response.body['HostedZone']['Comment'] = options[:comment]
          end

          response
        end
      end
    end
  end
end
