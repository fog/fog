require 'fog/core/parser'
require 'fog/aws/parsers/sqs/receive_message'

describe Fog::Parsers::AWS::SQS::ReceiveMessage do
  let(:parser) { Fog::Parsers::AWS::SQS::ReceiveMessage.new }

  let(:sent_timestamp) { 1322475007845 }
  let(:approximate_first_receive_timestamp) { 1322494017370 }

  let(:xml) do
    <<-XML
<?xml version="1.0"?>
<ReceiveMessageResponse xmlns="http://queue.amazonaws.com/doc/2009-02-01/">
  <ReceiveMessageResult>
    <Message>
      <MessageId>e4fbeece-7260-4106-807d-18255e43e687</MessageId>
      <ReceiptHandle>gH2qdC6bjNtuE/U+iA5J/5HQK/lgvsTY0Vj+gFEXyRlsRL+EDf9tgjLxAW9cdutwjqgV22jyQyTgFsYV+G0oQc2posQntKVMZKqOLlrJqbKSOUnsBtkoWoD2MxyacbuDTG0q0a9yS3RpPSN4lV8RN0BrJjfoeQDRQOn/RIxtAH9H4C4NasSLODB1xJWcO/KsZYRch0IWL89a4YgP060XCxAyKYqY8O+GvNhX5d59JRAI6tO2sx9wLwytIHNlG97DDnUGb/6PNuYPmoZcvYOdfhMQgP28rdrUW3B7Pai+dqE=</ReceiptHandle>
      <MD5OfBody>b425c09d8559b59dd989cf8c47caaf54</MD5OfBody>
      <Body>testmessage</Body>
      <Attribute><Name>SenderId</Name><Value>000000000000</Value></Attribute>
      <Attribute><Name>SentTimestamp</Name><Value>#{sent_timestamp}</Value></Attribute>
      <Attribute><Name>ApproximateReceiveCount</Name><Value>2</Value></Attribute>
      <Attribute><Name>ApproximateFirstReceiveTimestamp</Name><Value>#{approximate_first_receive_timestamp}</Value></Attribute>
    </Message>
  </ReceiveMessageResult>
  <ResponseMetadata><RequestId>72c77661-d4b5-45b9-8a82-a685c980e9dd</RequestId></ResponseMetadata>
</ReceiveMessageResponse>
    XML
  end

  def timestamp(attribute)
    body = Nokogiri::XML::SAX::PushParser.new(parser)
    body << xml
    body.finish
    response_body = parser.response
    response_body['Message'].first['Attributes'][attribute].utc
  end

  it "converts SentTimestamp to the same time as a Time-like object" do
    stamp = timestamp 'SentTimestamp'
    stamp.year.should == 2011
    stamp.month.should == 11
    stamp.day.should == 28
    stamp.hour.should == 10
    stamp.min.should == 10
    stamp.sec.should == 7
  end

  it "converts ApproximateFirstReceiveTimestamp to the same time as a Time-like object" do
    stamp = timestamp 'ApproximateFirstReceiveTimestamp'
    stamp.year.should == 2011
    stamp.month.should == 11
    stamp.day.should == 28
    stamp.hour.should == 15
    stamp.min.should == 26
    stamp.sec.should == 57
  end
end
