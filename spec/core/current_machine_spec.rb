require 'spec_helper'
require 'fog/core/current_machine'

describe Fog::CurrentMachine do
  context '#ip_address' do
    before(:each){ described_class.ip_address = nil }

    it 'should be threadsafe' do
      Net::HTTP.should_receive(:get_response).once{ Struct.new(:body).new('') }

      (1..10).map {
        Thread.new { described_class.ip_address }
      }.each{ |t| t.join }
    end

    it 'should remove trailing endline characters' do
      Net::HTTP.stub(:get_response){ Struct.new(:body).new("192.168.0.1\n") }

      described_class.ip_address.should == '192.168.0.1'
    end
  end
end
