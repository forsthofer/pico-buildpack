require "language_pack/virgo"
require "fileutils"

module LanguagePack
  class VirgoWeb < Virgo

    VIRGO_NAN_WEB_URL =  "http://virgo.eclipse.org.s3.amazonaws.com/virgo-nano-full-3.6.1.RELEASE.tar.gz".freeze
    WEBAPP_DIR = "pickup/app.war/".freeze

    def self.use?
      # Test for manifest in either original or compiled location
      File.exists?("META-INF/MANIFEST.MF") || File.exists?("#{WEBAPP_DIR}META-INF/MANIFEST.MF")
    end

    def name
      "Virgo Web"
    end

    def move_to_virgo
      FileUtils.mkdir_p "#{virgo_dir}/#{WEBAPP_DIR}"
      run_with_err_output("mv * #{virgo_dir}/#{WEBAPP_DIR}.")
    end

    def download_virgo(virgo_zip)
      run_with_err_output("curl --silent --location #{VIRGO_NANO_WEB_URL} --output #{virgo_zip}")
    end

  end
end