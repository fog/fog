require 'spec_helper'
require 'fog/core/current_machine'

describe Fog::CurrentMachine do
  context '#ip_address' do
    around(:each) do |example|
      old_mock = Excon.defaults[:mock]
      described_class.ip_address = nil
      begin
        Excon.defaults[:mock] = true
        example.run
      ensure
        Excon.defaults[:mock] = false
        Excon.stubs.clear
      end
    end
    it 'should be threadsafe' do
      Excon.stub({:method => :get, :path => '/'}, {:body => ''})

      (1..10).map {
        Thread.new { described_class.ip_address }
      }.each{ |t| t.join }
    end

    it 'should remove trailing endline characters' do
      Excon.stub({:method => :get,  :path => '/'}, {:body => "192.168.0.1\n"})

      described_class.ip_address.should == '192.168.0.1'
    end

  end
end
