require "language_pack/virgo"
require "fileutils"

module LanguagePack
  class VirgoOverlay < Virgo

    VIRGO_URL =  "http://virgo.eclipse.org.s3.amazonaws.com/virgo-tomcat-server-3.6.1.RELEASE.tar.gz".freeze

    def self.use?
      # Test for pickup directory in either original or compiled location
      File.exists?("pickup")
    end

    def name
      "Virgo Overlay"
    end

    def move_to_virgo
      run_with_err_output("mv pickup/* #{virgo_dir}/pickup/.")
      run_with_err_output("rm -rf pickup")
      run_with_err_output("mv repository/usr/* #{virgo_dir}/repository/usr/.")
      run_with_err_output("rm -rf repository")
    end

  end
end