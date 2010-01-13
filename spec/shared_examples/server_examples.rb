shared_examples_for "Server" do

  describe "#reboot" do

    it "should succeed" do
      subject.save
      subject.wait_for { ready? }
      subject.reboot.should be_true
    end

  end

  describe "#reload" do

    it "should reset attributes to remote state" do
      subject.save
      subject.wait_for { ready? }
      @reloaded = subject.reload
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
      subject.wait_for { ready? }
      @servers.get(subject.id).should_not be_nil
    end

  end

end
