require "spec_helper"

describe LanguagePack::VirgoOverlay, type: :with_temp_dir do

  attr_reader :tmpdir, :java_overlay_pack

  let(:appdir) { File.join(tmpdir, "app") }

  before do
    @java_overlay_pack = LanguagePack::VirgoOverlay.new(appdir)
    # TODO pass in Mock
    @java_overlay_pack.stub(:install_java)

    Dir.chdir(tmpdir) do
      Dir.mkdir("app")
      Dir.chdir(appdir) do
        Dir.mkdir("repository")
        Dir.mkdir("repository/usr")
        java_overlay_pack.stub(:download_virgo) do
          FileUtils.copy( File.expand_path("../../support/fake-virgo.tar.gz", __FILE__), ".virgo/virgo.tar.gz")
        end
        java_overlay_pack.stub(:install_database_drivers)
      end
    end
  end

  describe "detect" do

    it "should be used if pickup present" do
      Dir.chdir(appdir) do
        Dir.mkdir("pickup")
        LanguagePack::VirgoOverlay.use?.should == true
      end
    end

    it "should not be used if no pickup" do
      Dir.chdir(appdir) do
        LanguagePack::VirgoOverlay.use?.should == false
      end
    end
  end

  describe "compile" do

    before do
      Dir.mkdir("#{appdir}/pickup")
      FileUtils.touch "#{appdir}/pickup/fake.jar"
      FileUtils.touch "#{appdir}/repository/usr/dummy.jar"
    end

    it "should download and unpack Virgo to root directory" do
      java_overlay_pack.compile
      File.exists?(File.join(appdir, "bin", "startup.sh")).should == true
    end

    it "should remove specified Virgo files" do
      java_overlay_pack.compile
      %w[About.html about_files docs AboutKernel.html epl-v10.html AboutNano.html notice.html pickup/org.eclipse.virgo.apps.fake.jar].each do |file|
        if File.exists?(File.join(appdir, file))
          fail sprintf("%s was not removed", file)
        end
      end
    end

    it "should copy pickup" do
      java_overlay_pack.compile

      pickup_file = File.join(appdir, "pickup", "fake.jar")
      File.exists?(pickup_file).should == true
    end

    it "should copy repository/usr" do
      java_overlay_pack.compile

      repository_file = File.join(appdir, "repository", "usr", "dummy.jar")
      File.exists?(repository_file).should == true
    end

    it "should create a .profile.d with connector port and heap size in JAVA_OPTS" do
      java_overlay_pack.stub(:install_virgo)
      java_overlay_pack.compile
      profiled = File.join(appdir,".profile.d","java.sh")
      File.exists?(profiled).should == true
      script = File.read(profiled)
      script.should include("-Xmx$MEMORY_LIMIT")
      script.should include("-Xms$MEMORY_LIMIT")
      script.should include("-Dhttp.port=$VCAP_APP_PORT")
      script.should_not include("-Djava.io.tmpdir=$TMPDIR")
    end

    it "should add template tomcat-server.xml to Virgo for configuration of web port" do
      java_overlay_pack.compile
      server_xml = File.join(appdir,"configuration","tomcat-server.xml")
      File.exists?(server_xml).should == true
      File.read(server_xml).should include("http.port")
    end
  end

  describe "release" do
    it "should return the Virgo start script as default web process" do
      java_overlay_pack.release.should == {
          "addons" => [],
          "config_vars" => {},
          "default_process_types" => { "web" => "./bin/startup.sh -clean" }
      }.to_yaml
    end
  end
end
