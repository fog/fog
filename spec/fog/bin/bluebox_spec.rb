require "spec_helper"
require "fog/bin"
require "helpers/bin"

describe Bluebox do
  include Fog::BinSpec

  let(:subject) { Bluebox }

  describe "#services" do
    it "includes all services" do
      assert_includes Bluebox.services, :compute
      assert_includes Bluebox.services, :dns
      assert_includes Bluebox.services, :blb
    end
  end

  describe "#class_for" do
    describe "when requesting compute service" do
      it "returns correct class" do
        assert_equal Fog::Compute::Bluebox, Bluebox.class_for(:compute)
      end
    end

    describe "when requesting dns service" do
      it "returns correct class" do
        assert_equal Fog::DNS::Bluebox, Bluebox.class_for(:dns)
      end
    end

    describe "when requesting blb service" do
      it "returns correct class" do
        assert_equal Fog::Bluebox::BLB, Bluebox.class_for(:blb)
      end
    end
  end

  describe "#[]" do
    describe "when requesting compute service" do
      it "returns instance" do
        Fog::Compute::Bluebox.stub(:new, "instance") do
          assert_equal "instance", Bluebox[:compute]
        end
      end
    end

    describe "when requesting dns service" do
      it "returns instance" do
        Fog::DNS::Bluebox.stub(:new, "instance") do
          assert_equal "instance", Bluebox[:dns]
        end
      end
    end
  end
end
