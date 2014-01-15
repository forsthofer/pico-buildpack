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

require 'spec_helper'
require 'component_helper'
require 'fileutils'
require 'java_buildpack/repository/configured_item'
require 'java_buildpack/util/tokenized_version'
require 'java_buildpack/container/virgo'
require 'logging_helper'

describe JavaBuildpack::Container::Virgo do
  include_context 'component_helper'
  include_context 'logging_helper'

  it 'should detect pickup',
     app_fixture: 'container_virgo' do

    detected = component.detect

    expect(detected).to include("virgo=#{version}")
  end

  it 'should not detect when pickup is absent',
     app_fixture: 'container_main' do

    detected = component.detect

    expect(detected).to be_nil
  end

  it 'should extract Java from a GZipped TAR',
     app_fixture:   'container_virgo',
     cache_fixture: 'stub-virgo.zip' do

    component.compile

    expect(sandbox + 'bin/startup.sh').to exist

    expect(sandbox + 'pickup/org.eclipse.virgo.apps.splash_3.6.2.RELEASE.jar').not_to exist

    tomcat_server          = sandbox + 'configuration' + 'tomcat-server.xml'
    expected_tomcat_server = File.new(File.join 'resources', 'virgo', 'configuration', 'tomcat-server.xml')
    expect(FileUtils.compare_file(expected_tomcat_server, tomcat_server)).to be
  end

  context do
    let(:container_libs_dir) { app_dir + '.spring-insight/container-libs' }

    before do
      FileUtils.mkdir_p container_libs_dir
      FileUtils.cp_r 'spec/fixtures/framework_spring_insight/.java-buildpack/spring_insight/weaver/insight-weaver-1.2.4-CI-SNAPSHOT.jar',
                     container_libs_dir
    end

    it 'should fail to link additional libs',
       app_fixture:   'container_virgo',
       cache_fixture: 'stub-virgo.zip' do

      component.compile

      expect(stderr.string).to match /ERROR Virgo does not have a linear application classpath/
    end

  end

  it 'should return command',
     app_fixture: 'container_virgo' do

    # expect(component.release).to eq("#{java_home.as_env_var} JAVA_OPTS=\"-Dhttp.port=$PORT test-opt-1 test-opt-2\" " +
    #                                    '$PWD/.java-buildpack/virgo/bin/startup.sh -clean')
    # Work around Virgo bug 425655
    expect(component.release).to eq("#{java_home.as_env_var} JMX_OPTS=\"-Dhttp.port=$PORT test-opt-1 test-opt-2\" " +
                                        '$PWD/.java-buildpack/virgo/bin/startup.sh -clean')
  end

end
