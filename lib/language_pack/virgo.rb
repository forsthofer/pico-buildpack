module LanguagePack
  class Virgo < Java

    VIRGO_URL =  "http://virgo.eclipse.org.s3.amazonaws.com/virgo-tomcat-server-3.6.1.RELEASE.tar.gz".freeze

    def compile
      Dir.chdir(build_path) do
        install_java
        install_virgo
        remove_virgo_files
        copy_resources
        move_to_virgo
        move_virgo_to_root
        setup_profiled
      end
    end

    def install_virgo
      FileUtils.mkdir_p virgo_dir
      virgo_tarball="#{virgo_dir}/virgo.tar.gz"

      download_virgo virgo_tarball

      run_with_err_output("tar pxzf #{virgo_tarball} -C #{virgo_dir}")
      FileUtils.rm_rf virgo_tarball
      unless File.exists?("#{virgo_dir}/bin/startup.sh")
        puts "Unable to retrieve Virgo"
        exit 1
      end
    end

    def remove_virgo_files
      %w(notice.html epl-v10.html docs work [Aa]bout* pickup/org.eclipse.virgo.apps.*).each do |file|
        Dir.glob("#{virgo_dir}/#{file}") do |entry|
          FileUtils.rm_rf(entry)
        end
      end
    end

    def copy_resources
      # Configure server.xml with variable HTTP port
      run_with_err_output("cp -r #{File.expand_path('../../../resources/virgo', __FILE__)}/* #{virgo_dir}")
    end

    def move_virgo_to_root
      run_with_err_output("mv #{virgo_dir}/* . && rm -rf #{virgo_dir}")
    end

    def default_process_types
      {
          "web" => "./bin/startup.sh -clean"
      }
    end

    def java_opts
      # TODO proxy settings?
      # Don't override Virgo's temp dir setting
      opts = super.merge({"-Dhttp.port=" => "$VCAP_APP_PORT"})
      opts.delete("-Djava.io.tmpdir=")
      opts
    end

     def virgo_dir
      ".virgo"
    end

     def download_virgo(virgo_zip)
      run_with_err_output("curl --silent --location #{VIRGO_URL} --output #{virgo_zip}")
    end
  end
end
