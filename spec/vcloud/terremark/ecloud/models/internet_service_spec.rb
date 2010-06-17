require File.join(File.dirname(__FILE__),'..','..','..','spec_helper')

if Fog.mocking?
  describe "Fog::Vcloud::Terremark::Ecloud::InternetService", :type => :mock_tmrk_ecloud_model do
    before do
      @mock_ip = @mock_vdc[:public_ips].first
      @mock_service = @mock_ip[:services].first
      @mock_service_uri = "#{@base_url}/extensions/internetService/#{@mock_service[:id]}"
    end

    subject { @vcloud.vdcs[0].public_ips[0].internet_services[0] }

    describe :class do
      subject { Fog::Vcloud::Terremark::Ecloud::InternetService }

      it { should have_identity :href }
      it { should have_only_these_attributes [:href, :name, :id, :protocol, :port, :enabled, :description, :public_ip, :timeout, :redirect_url, :monitor] }
    end

    context "with no uri" do

      subject { Fog::Vcloud::Terremark::Ecloud::InternetService.new() }
      it { should have_all_attributes_be_nil }

    end

    context "as a collection member" do
      subject { @vcloud.vdcs[0].public_ips[0].internet_services[0].reload; @vcloud.vdcs[0].public_ips[0].internet_services[0] }

      let(:public_ip) {
        pip = @vcloud.get_public_ip(@vcloud.vdcs[0].public_ips[0].internet_services[0].public_ip[:Href]).body
        pip.delete_if{ |k,v| [:xmlns, :xmlns_i].include?(k)}
        pip
      }
      let(:composed_public_ip_data) { @vcloud.vdcs[0].public_ips[0].internet_services[0].send(:_compose_ip_data) }
      let(:composed_service_data) { @vcloud.vdcs[0].public_ips[0].internet_services[0].send(:_compose_service_data) }

      it { should be_an_instance_of Fog::Vcloud::Terremark::Ecloud::InternetService }

      its(:href)                  { should == @mock_service_uri }
      its(:identity)              { should == @mock_service_uri }
      its(:name)                  { should == @mock_service[:name] }
      its(:id)                    { should == @mock_service[:id] }
      its(:protocol)              { should == "HTTP" }
      its(:port)                  { should == "80" }
      its(:enabled)               { should == "true" }
      its(:description)           { should == "Web Servers" }
      its(:public_ip)             { should == public_ip }
      its(:timeout)               { should == "2" }
      its(:redirect_url)          { should == "" }
      its(:monitor)               { should == "" }

      specify { composed_public_ip_data[:href].should == public_ip[:Href].to_s }
      specify { composed_public_ip_data[:name].should == public_ip[:Name] }
      specify { composed_public_ip_data[:id].should == public_ip[:Id] }

      specify { composed_service_data[:href].should == subject.href.to_s }
      specify { composed_service_data[:name].should == subject.name }
      specify { composed_service_data[:id].should == subject.id.to_s }
      specify { composed_service_data[:protocol].should == subject.protocol }
      specify { composed_service_data[:port].should == subject.port.to_s }
      specify { composed_service_data[:enabled].should == subject.enabled.to_s }
      specify { composed_service_data[:description].should == subject.description }
      specify { composed_service_data[:timeout].should == subject.timeout.to_s }
    end
  end
else
end
