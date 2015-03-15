require "spec_helper"
require "fog/bin"
require "helpers/bin"

describe Atmos do
  include Fog::BinSpec

  let(:subject) { Atmos }

  describe "#services" do
    it "includes all services" do
      assert_includes Atmos.services, :storage
    end
  end

  describe "#class_for" do
    describe "when requesting storage service" do
      it "returns correct class" do
        assert_equal Fog::Storage::Atmos, Atmos.class_for(:storage)
      end
    end
  end

  describe "#[]" do
    describe "when requesting storage service" do
      it "returns instance" do
        Fog::Storage::Atmos.stub(:new, "instance") do
          assert_equal "instance", Atmos[:storage]
        end
      end
    end
  end
end
