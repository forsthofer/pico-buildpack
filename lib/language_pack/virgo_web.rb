require "language_pack/virgo"
require "fileutils"

module LanguagePack
  class VirgoWeb < Virgo

    VIRGO_URL =  "http://virgo.eclipse.org.s3.amazonaws.com/virgo-tomcat-server-3.6.1.RELEASE.tar.gz".freeze
    WEBAPP_DIR = "pickup/app.war/".freeze

    def self.use?
      # Test for manifest in either original or compiled location
      File.exists?("META-INF/MANIFEST.MF") || File.exists?("#{WEBAPP_DIR}META-INF/MANIFEST.MF")
    end

    def name
      "Virgo Web"
    end

    def copy_webapp_to_virgo
      FileUtils.mkdir_p "#{virgo_dir}/#{WEBAPP_DIR}"
      run_with_err_output("mv * #{virgo_dir}/#{WEBAPP_DIR}.")
    end

  end
end