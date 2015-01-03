module Fog
  module BinSpec
    extend Minitest::Spec::DSL

    it "responds to available?" do
      assert_respond_to subject, :available?
    end

    it "responds to class_for" do
      assert_respond_to subject, :class_for
    end

    it "#class_for raises ArgumentError for unknown services" do
      assert_raises(ArgumentError) { subject.class_for(:unknown) }
    end

    it "responds to collections" do
      skip if subject == ::Google
      assert_respond_to subject, :collections
    end

    it "responds to []" do
      assert_respond_to subject, :[]
    end

    it "#[] when unknown service is passed raises ArgumentError" do
      assert_raises(ArgumentError) { subject[:bad_service] }
    end

    it "responds to services" do
      assert_respond_to subject, :services
    end
  end
end
