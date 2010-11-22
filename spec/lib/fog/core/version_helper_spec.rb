require Pathname(__FILE__).ascend{|d| h=d+'spec_helper.rb'; break h if h.file?}

module Fog

  describe VersionHelper do

    before(:all) do
      @version_dir = ::Fog::Bdd.core_dir
      @version_helper = ::Fog::Bdd.version_helper
    end

    it "should record the initialization directory" do
      @version_helper.version_dir.should be_an_instance_of(String)
      @version_helper.version_dir.should == @version_dir.to_s
    end

    it "should point to the  version file directory" do
      ver_file = File.join(@version_helper.version_dir, 'version.rb')
      File.exist?(ver_file).should be_true
    end

    it "should point to the version file" do
      File.exists?(@version_helper.version_path).should be_true
    end

    it "should provide major version numbers" do
      @version_helper.major.should be_an_instance_of(Fixnum)
    end

    it "should provide minor version numbers" do
      @version_helper.minor.should be_an_instance_of(Fixnum)
    end

    it "should provide patch version numbers" do
      @version_helper.patch.should be_an_instance_of(Fixnum)
    end

    it "should provide build version numbers" do
      @version_helper.build.should be_an_instance_of(Fixnum)
    end

    it "#to_s should provide version string" do
      @version_helper.to_s.should be_an_instance_of(String)
    end

  end

  describe VersionHelper do
    describe "#unset_version " do
      before(:all) do
        @version_dir = ::Fog::Bdd.core_dir
        @version_helper = ::Fog::Bdd.version_helper
      end

      it "should unset Fog::Version constants idempotently" do
        expect {
          @version_helper.unset_version
          }.should_not raise_error
        expect {
          @version_helper.unset_version
          }.should_not raise_error
      end

      it "should unset version attributes" do
        @version_helper.unset_version
        @version_helper.major.should be_nil
        @version_helper.minor.should be_nil
        @version_helper.patch.should be_nil
        @version_helper.build.should be_nil
        @version_helper.to_s.should == ""
      end

      it "should unset Fog::Version constants" do
        @version_helper.unset_version
        expect {
          ::Fog::Version::MAJOR
          }.to raise_error(
          NameError,
          /uninitialized constant Fog::Version::MAJOR/
          )
        expect {
          ::Fog::Version::MINOR
          }.to raise_error(
          NameError,
          /uninitialized constant Fog::Version::MINOR/
          )
        expect {
          ::Fog::Version::PATCH
          }.to raise_error(
          NameError,
          /uninitialized constant Fog::Version::PATCH/
          )
        expect {
          ::Fog::Version::BUILD
          }.to raise_error(
          NameError,
          /uninitialized constant Fog::Version::BUILD/
          )
        expect {
          ::Fog::Version::STRING
          }.to raise_error(
          NameError,
          /uninitialized constant Fog::Version::STRING/
          )
      end

      it "should unset Fog::VERSION constant" do
        @version_helper.unset_version
        expect {
          ::Fog::VERSION
          }.to raise_error(
          NameError,
          /uninitialized constant Fog::VERSION/
          )
      end

      it "should unset version constants (idempotently)" do
        @version_helper.unset_version
        @version_helper.unset_version
      end
    end

    describe "#preview_version :major" do
      context "generating descriptions for the release rake tasks " do
        before(:all) do
          @version_dir = ::Fog::Bdd.core_dir
          @version_helper = ::Fog::Bdd.version_helper
        end

        it "should return a string of what the version number will be after the version bump" do
          mm = @version_helper.major
          @version_helper.preview_version(:major).should match /#{mm+1}\.0\.0\.0/
        end
      end
    end
    describe "#preview_version :minor" do
      context "generating descriptions for the release rake tasks" do
        before(:all) do
          @version_dir = ::Fog::Bdd.core_dir
          @version_helper = ::Fog::Bdd.version_helper
        end

        it "should return a string of what the version number will be after the version bump" do
          mm = @version_helper.minor
          @version_helper.preview_version(:minor).should match /(\d+)\.#{mm+1}\.0\.0/
        end
      end
    end
    describe "#preview_version :patch" do
      context "generating descriptions for the release rake tasks" do
        before(:all) do
          @version_dir = ::Fog::Bdd.core_dir
          @version_helper = ::Fog::Bdd.version_helper
        end

        it "should return a string of what the version number will be after the version bump" do
          mm = @version_helper.patch
          @version_helper.preview_version(:patch).should match /(\d+)\.(\d+)\.#{mm+1}\.0/
        end
      end
    end
    describe "#preview_version :build" do
      context "generating descriptions for the release rake tasks" do
        before(:all) do
          @version_dir = ::Fog::Bdd.core_dir
          @version_helper = ::Fog::Bdd.version_helper
        end

        it "should return a string of what the version number will be after the version bump" do
          mm = @version_helper.build
          @version_helper.preview_version(:build).should match /(\d+)\.(\d+)\.(\d+)\.#{mm+1}/
        end
      end
    end

    describe "#reset_attributes " do
      before(:all) do
        @version_dir = ::Fog::Bdd.core_dir
        @version_helper = ::Fog::Bdd.version_helper
      end
      it "should reset version constants when not initially set" do
        expect {
          @version_helper.reset_attributes
          }.should_not raise_error
      end
    end

    describe "#reset_version " do
      before(:all) do
        @version_dir = ::Fog::Bdd.core_dir
        @version_helper = ::Fog::Bdd.version_helper
      end

      it "should reset version constants when not initially set" do
        expect {
          @version_helper.reset_version
          }.should_not raise_error
        expect {
          @version_helper.reset_version
          }.should_not raise_error
      end

      it "should reset version constants" do
        @version_helper.reset_version
        expect {
          ::Fog::Version::MAJOR
          }.should_not raise_error
        expect {
          ::Fog::Version::MINOR
          }.should_not raise_error
        expect {
          ::Fog::Version::PATCH
          }.should_not raise_error
        expect {
          ::Fog::Version::BUILD
          }.should_not raise_error
        expect {
          ::Fog::Version::STRING
          }.should_not raise_error
      end

      it "should reset version constants (idempotently)" do
        @version_helper.unset_version
        @version_helper.reset_version
        expect {
          ::Fog::Version::MAJOR
          }.should_not raise_error
        expect {
          ::Fog::Version::MINOR
          }.should_not raise_error
        expect {
          ::Fog::Version::PATCH
          }.should_not raise_error
        expect {
          ::Fog::Version::BUILD
          }.should_not raise_error
        expect {
          ::Fog::Version::STRING
          }.should_not raise_error
      end

    end
  end

  describe VersionHelper do
    before(:all) do
      @version_dir = ::Fog::Bdd.core_dir
      @version_helper = ::Fog::Bdd.version_helper
    end

    describe "#increment :major" do
      it "should increment major version number by 1" do
         expect {
          @version_helper.increment(:major)
          }.to change{ @version_helper.major }.by(1)
          @version_helper.to_s.should match /(\d+).0.0.0/
      end
    end

    describe "#increment :minor" do
      it "should increment minor version number by 1" do
         expect {
          @version_helper.increment(:minor)
          }.to change{ @version_helper.minor }.by(1)
          @version_helper.to_s.should match /(\d+).1.0.0/
      end
    end

    describe "#increment :patch" do
      it "should increment patch version number by 1" do
         expect {
          @version_helper.increment(:patch)
          }.to change{ @version_helper.patch }.by(1)
          @version_helper.to_s.should match /(\d+).1.1.0/
      end
    end

    describe "#increment :build" do
      it "should increment build version number by 1" do
         expect {
          @version_helper.increment(:build)
          }.to change{ @version_helper.build }.by(1)
          @version_helper.to_s.should match /(\d+).1.1.1/
      end
    end

    describe "#increment :custom, hash" do
      it "should change all build version numbers to those given" do
        incr = 3
        hsh = { :major => @version_helper.major + incr,
                :minor => @version_helper.minor + incr,
                :patch => @version_helper.patch + incr,
                :build => @version_helper.build + incr }
        pre = "#{@version_helper.major}.#{@version_helper.minor}.#{@version_helper.patch}.#{@version_helper.build}"
        post = "#{hsh[:major]}.#{hsh[:minor]}.#{hsh[:patch]}.#{hsh[:build]}"
        expect {
          @version_helper.increment(:custom, hsh)
          }.to change{ @version_helper.to_s }.from(pre).to(post)
      end

      it "should not change build version numbers when not given them" do
        incr = 2
        hsh = { :minor => @version_helper.minor + incr,
                :patch => @version_helper.patch + incr }
        pre = "#{@version_helper.major}.#{@version_helper.minor}.#{@version_helper.patch}.#{@version_helper.build}"
        post = "#{@version_helper.major}.#{hsh[:minor]}.#{hsh[:patch]}.#{@version_helper.build}"
        expect {
          @version_helper.increment(:custom, hsh)
          }.to change{ @version_helper.to_s }.from(pre).to(post)
      end
    end

  end

  describe VersionHelper do
    include FakeFS::SpecHelpers

    before(:all) do
      @version_dir = ::Fog::Bdd.core_dir
      @version_helper = ::Fog::Bdd.version_helper
    end
    after(:all) do
    end

    describe "#bump_major" do
      context "a major version release" do
        it "should increment the version number by 1" do
          @version_helper.should_receive(:increment).with(:major)
          @version_helper.bump_major
        end
        it "should write the updated version file" do
           @version_helper.should_receive(:to_ruby)
           @version_helper.bump_major
        end
        it "should set version constant from the updated version file" do
          @version_helper.should_receive(:reset_constants)
          @version_helper.bump_major
        end
        it "should set version attributes from the updated version constants" do
          @version_helper.should_receive(:reset_attributes)
          @version_helper.bump_major
        end
        # TODO: The following should pass when FakeFS can fake load (or fakefs-require gem improves)
        # it "should return the updated version string" do
        #   @version_helper.bump_major
        #   @version_helper.to_s.should match /(\d+).0.0.0/
        # end
      end
    end

    describe "#bump_minor" do
      context "a minor version release" do
        it "should increment the version number by 1" do
          @version_helper.should_receive(:increment).with(:minor)
          @version_helper.bump_minor
        end
        # TODO: The following should pass when FakeFS can fake load (or fakefs-require gem improves)
        # it "should return the updated version string" do
        #  @version_helper.bump_minor
        #  @version_helper.to_s.should match /(\d+).1.0.0/
        # end
      end
    end

    describe "#bump_patch" do
      context "a patch version release" do
        it "should increment the version number by 1" do
          @version_helper.should_receive(:increment).with(:patch)
          @version_helper.bump_patch
        end
        # TODO: The following should pass when FakeFS can fake load (or fakefs-require gem improves)
        # it "should return the updated version string" do
        #  @version_helper.bump_patch
        #  @version_helper.to_s.should match /(\d+).1.1.0/
        # end
      end
    end

    describe "#bump_build" do
      context "a build version release" do
        it "should increment the version number by 1" do
          @version_helper.should_receive(:increment).with(:build)
          @version_helper.bump_build
        end
        # TODO: The following should pass when FakeFS can fake load (or fakefs-require gem improves)
        # it "should return the updated version string" do
        #  @version_helper.bump_patch
        #  @version_helper.to_s.should match /(\d+).1.1.1/
        # end
      end
    end

    describe "#bump_custom(args)" do
      context "a custom version release" do
        before :all do
          @custom_ver_args = {:major => 99}
        end
        it "should increment the version number by 1" do
          @version_helper.should_receive(:increment).with(:custom, hash_including(@custom_ver_args))
          @version_helper.bump_custom(@custom_ver_args)
        end
        # TODO: The following should pass when FakeFS can fake load (or fakefs-require gem improves)
        # it "should return the updated version string" do
        #  @version_helper.bump_patch
        #  @version_helper.to_s.should match /(\d+).n.n.n/
        # end
      end
    end

  end


end


