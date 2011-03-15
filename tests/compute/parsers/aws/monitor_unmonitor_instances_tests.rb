require 'fog/compute/parsers/aws/monitor_unmonitor_instances'

Shindo.tests('AWS::Compute::MonitorUnmonitorInstances | monitor/unmonitor parser') do

  tests('success') do

    tests('#parse') do

      aws_result = <<-AWS
        <UnmonitorInstancesResponse xmlns="http://ec2.amazonaws.com/doc/2010-11-15/">
           <requestId>59dbff89-35bd-4eac-99ed-be587EXAMPLE</requestId>
           <instancesSet>
              <item>
                 <instanceId>i-43a4412a</instanceId>
                 <monitoring>
                    <state>enabled</state>
                 </monitoring>
              </item>
              <item>
                 <instanceId>i-23a3397d</instanceId>
                 <monitoring>
                    <state>disabled</state>
                 </monitoring>
              </item>
           </instancesSet>
        </UnmonitorInstancesResponse>
      AWS

      parser = Fog::Parsers::AWS::Compute::MonitorUnmonitorInstances.new
      body = Nokogiri::XML::SAX::PushParser.new(parser)
      body << aws_result

      test('requestId') { parser.response['requestId'] == '59dbff89-35bd-4eac-99ed-be587EXAMPLE' }

      test('enabled') do
        selected = parser.response['instancesSet'].select { |item| item['instanceId'] == 'i-43a4412a' }[0]
        selected['monitoring'] == 'enabled'
      end

      test('disabled') do
        selected = parser.response['instancesSet'].select { |item| item['instanceId'] == 'i-23a3397d' }[0]
        selected['monitoring'] == 'disabled'
      end
      
    end

  end

end
