require "spec_helper"
require "fog/bin"
require "helpers/bin"

describe Brightbox do
  include Fog::BinSpec

  let(:subject) { Brightbox }

  describe "#services" do
    it "includes all services" do
      assert_includes Brightbox.services, :compute
      assert_includes Brightbox.services, :storage
    end
  end

  describe "#class_for" do
    describe "when requesting compute service" do
      it "returns correct class" do
        assert_equal Fog::Compute::Brightbox, Brightbox.class_for(:compute)
      end
    end

    describe "when requesting storage service" do
      it "returns correct class" do
        assert_equal Fog::Storage::Brightbox, Brightbox.class_for(:storage)
      end
    end
  end
end
