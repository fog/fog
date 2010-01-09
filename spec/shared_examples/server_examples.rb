shared_examples_for "Server" do

  describe "#destroy" do

    it "should return true if the server is deleted" do
      subject.save
      subject.destroy.should be_true
    end

  end

  describe "#reload" do

    it "should reset attributes to remote state" do
      subject.save
      eventually do
        @reloaded = subject.reload
      end
      subject.attributes.should == @reloaded.attributes
    end

  end

  describe "#save" do

    it "should return true when it succeeds" do
      subject.save.should be_true
    end

    it "should not exist remotely before save" do
      @servers.get(subject.id).should be_nil
    end

    it "should exist remotely after save" do
      subject.save
      eventually do
        @servers.get(subject.id).should_not be_nil
      end
    end

  end

end
