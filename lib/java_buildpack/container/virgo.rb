# Encoding: utf-8
# Cloud Foundry Java Buildpack
# Copyright 2013 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'fileutils'
require 'java_buildpack/base_component'
require 'java_buildpack/container'
require 'java_buildpack/container/container_utils'
require 'java_buildpack/repository/configured_item'
require 'java_buildpack/util/format_duration'
require 'java_buildpack/util/java_main_utils'
require 'java_buildpack/util/resource_utils'
require 'java_buildpack/versioned_dependency_component'

module JavaBuildpack::Container

  # Encapsulates the detect, compile, and release functionality for Virgo applications.
  class Virgo < JavaBuildpack::VersionedDependencyComponent

    def initialize(context)
      super('Virgo', context)

      if supports?
        @virgo_version, @virgo_uri = JavaBuildpack::Repository::ConfiguredItem.find_item(@component_name, @configuration)
      else
        @virgo_version, @virgo_uri = nil, nil
      end
    end

    def detect
      @virgo_version ? [virgo_id(@virgo_version)] : nil
    end

    def compile
      download_zip virgo_home
      clear_pickup
      JavaBuildpack::Util::ResourceUtils.copy_resources('virgo', virgo_home)
      link_applications
      link_dependencies
      link_libs
    end

    def release
      @java_opts << "-D#{KEY_HTTP_PORT}=$PORT"

      # Don't override Virgo's temp dir setting
      @java_opts = @java_opts.select { |opt| opt !~ /-Djava\.io\.tmpdir/ }

      java_home_string = "JAVA_HOME=$PWD/#{@java_home}"
      java_opts_string = ContainerUtils.space("JAVA_OPTS=\"#{ContainerUtils.to_java_opts_s(@java_opts)}\"")
      start_script_string = ContainerUtils.space(@application.relative_path_to(virgo_home + 'bin' + 'startup.sh'))

      "#{java_home_string}#{java_opts_string}#{start_script_string} -clean"
    end

    protected

    # The unique identifier of the component, incorporating the version of the dependency (e.g. +virgo=3.6.1.RELEASE+)
    #
    # @param [String] version the version of the dependency
    # @return [String] the unique identifier of the component
    def virgo_id(version)
      "#{@parsable_component_name}=#{version}"
    end

    # Whether or not this component supports this application
    #
    # @return [Boolean] whether or not this component supports this application
    def supports?
      pickup?
    end

    private

    KEY_HTTP_PORT = 'http.port'.freeze

    PICKUP_DIRECTORY = 'pickup'.freeze

    USER_REPOSITORY_DIRECTORY = 'repository/usr'.freeze

    def clear_pickup
      FileUtils.rm_rf(pickup)
      FileUtils.mkdir(pickup)
    end

    def container_libs_directory
      @application.component_directory 'container-libs'
    end

    def link_applications
      application_pickup.children.each { |child| FileUtils.ln_sf child.relative_path_from(pickup), pickup }
    end

    def link_dependencies
      application_user_repository.each { |child| FileUtils.ln_sf child.relative_path_from(user_repository), user_repository } if user_repository?
    end

    def link_libs
      libs = ContainerUtils.libs(@app_dir, @lib_directory)

      if libs && !libs.empty?
        fail "Virgo does not have a linear application classpath, so libraries #{libs} cannot be linked."
      end
    end

    def virgo_home
      @application.component_directory 'virgo'
    end

    def virgo_lib
      virgo_home + 'lib'
    end

    def user_repository
      virgo_home + USER_REPOSITORY_DIRECTORY
    end

    def pickup
      virgo_home + PICKUP_DIRECTORY
    end

    def pickup?
      application_pickup.exist?
    end

    def application_pickup
      @application.child(PICKUP_DIRECTORY)
    end

    def application_user_repository
      @application.child(USER_REPOSITORY_DIRECTORY)
    end

    def user_repository?
      application_user_repository.exist?
    end

  end

end
