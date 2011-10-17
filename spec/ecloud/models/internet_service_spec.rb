require 'ecloud/spec_helper'

if Fog.mocking?
  describe "Fog::Compute::Ecloud::InternetService", :type => :mock_tmrk_ecloud_model do
    subject { @vcloud.vdcs[0].public_ips[0].internet_services[0] }

    describe :class do
      subject { Fog::Compute::Ecloud::InternetService }

      it { should have_identity(:href) }
      it { should have_only_these_attributes([:href, :name, :id, :protocol, :port, :enabled, :description, :public_ip, :timeout, :redirect_url, :monitor, :backup_service_data]) }
    end

    context "with no uri" do

      subject { Fog::Compute::Ecloud::InternetService.new() }
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

      it { should be_an_instance_of(Fog::Compute::Ecloud::InternetService) }

      its(:href)               { should == @mock_service.href }
      its(:identity)           { should == @mock_service.href }
      its(:name)               { should == @mock_service.name }
      its(:id)                 { should == @mock_service.object_id.to_s }
      its(:protocol)           { should == @mock_service.protocol }
      its(:port)               { should == @mock_service.port.to_s }
      its(:enabled)            { should == @mock_service.enabled.to_s }
      its(:description)        { should == @mock_service.description }
      its(:public_ip)          { should == public_ip }
      its(:timeout)            { should == @mock_service.timeout.to_s }
      its(:redirect_url)       { should == @mock_service.redirect_url }
      its(:monitor)            { should == nil }
      its(:backup_service_uri) { should be_nil }

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

      context "with a backup internet service" do
        before { @mock_service[:backup_service] = @mock_backup_service }

        its(:backup_service_uri) { should == @mock_backup_service.href }
      end

      describe "#backup_service_uri=" do
        specify do
          expect { subject.backup_service_uri = @mock_backup_service.href }.
            to change { subject.backup_service_uri }.from(nil).to(@mock_backup_service.href)
        end

        specify do
          expect { subject.backup_service_uri = @mock_backup_service.href }.
            to change { subject.send(:_compose_service_data)[:backup_service_uri] }.from(nil).to(@mock_backup_service.href)
        end
      end

      describe "disable monitoring via #monitor=" do
        specify do
          expect { subject.monitor = {:type => "Disabled", :is_enabled => "true" }; subject.save }.to change {subject.monitor}.from(nil).to(ecloud_disabled_default_monitor)
        end

      end

      describe "disable monitoring via #disable_monitor" do
        specify do
          expect { subject.disable_monitor }.to change {subject.monitor}.from(nil).to(ecloud_disabled_default_monitor)
        end
      end

      context "with a disabled monitor" do
        before { subject.disable_monitor }

        describe "enable ping monitoring via #enable_ping_monitor" do
          specify do
            expect { subject.enable_ping_monitor }.to change {subject.monitor}.from(ecloud_disabled_default_monitor).to(nil)
          end
        end
      end
    end
  end
else
end
