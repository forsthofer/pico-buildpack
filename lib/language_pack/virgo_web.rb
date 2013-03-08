require "language_pack/virgo"
require "fileutils"

module LanguagePack
  class VirgoWeb < Virgo

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

  end
end