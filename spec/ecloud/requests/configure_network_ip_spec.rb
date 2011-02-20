require 'ecloud/spec_helper'

if Fog.mocking?
  describe "Fog::Ecloud, initialized w/ the TMRK Ecloud module", :type => :mock_tmrk_ecloud_request do
    subject { @vcloud }

    it { should respond_to(:configure_network_ip) }

    describe "#configure_network_ip" do
      let(:original_network_ip) { @vcloud.get_network_ip(@mock_network_ip.href).body }
      let(:network_ip_data) do
        {
          :id => original_network_ip[:Id],
          :href => original_network_ip[:Href],
          :name => original_network_ip[:Name],
          :status => original_network_ip[:Status],
          :server => original_network_ip[:Server],
          :rnat => "1.2.3.4"
        }
      end

      context "with a valid network ip uri" do

        subject { @vcloud.configure_network_ip(@mock_network_ip.href, network_ip_data) }

        it_should_behave_like "all responses"

        describe "#body" do
          subject { @vcloud.configure_network_ip(@mock_network_ip.href, network_ip_data).body }

          #Stuff that shouldn't change
          its(:Href) { should == @mock_network_ip.href }
          its(:Id) { should == @mock_network_ip.object_id.to_s }
          its(:Name) { should == @mock_network_ip.ip }
          its(:Status) { should == @mock_network_ip.status }

          #Stuff that should change
          it "should change the rnat" do
            expect { subject }.to change { @vcloud.get_network_ip(@mock_network_ip.href).body[:RnatAddress] }.
              from(@mock_network.rnat).
              to(network_ip_data[:rnat])
          end
        end

      end

      context "with a nodes uri that doesn't exist" do
        subject { lambda { @vcloud.configure_network_ip(URI.parse('https://www.fakey.c/piv8vc99'), network_ip_data) } }

        it_should_behave_like "a request for a resource that doesn't exist"
      end
    end
  end
else
end
