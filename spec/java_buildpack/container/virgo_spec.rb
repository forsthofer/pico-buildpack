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
require 'fileutils'
require 'java_buildpack/application'
require 'java_buildpack/container/virgo'

module JavaBuildpack::Container

  describe Virgo do

    VIRGO_VERSION = JavaBuildpack::Util::TokenizedVersion.new('3.6.1_RELEASE')

    VIRGO_DETAILS = [VIRGO_VERSION, 'test-virgo-uri']

    let(:application_cache) { double('ApplicationCache') }

    before do
      $stdout = StringIO.new
      $stderr = StringIO.new
    end

    it 'should detect pickup' do
      JavaBuildpack::Repository::ConfiguredItem.stub(:find_item) { |&block| block.call(VIRGO_VERSION) if block }
      .and_return(VIRGO_DETAILS)
      detected = Virgo.new(
          app_dir: 'spec/fixtures/container_virgo',
          application: JavaBuildpack::Application.new('spec/fixtures/container_virgo'),
          configuration: {}
      ).detect

      expect(detected).to include('virgo=3.6.1_RELEASE')
    end

    it 'should not detect when pickup is absent' do
      detected = Virgo.new(
          app_dir: 'spec/fixtures/container_main',
          application: JavaBuildpack::Application.new('spec/fixtures/container_main'),
          configuration: {}
      ).detect

      expect(detected).to be_nil
    end

    it 'should extract Virgo from a zip' do
      Dir.mktmpdir do |root|
        Dir.mkdir File.join(root, 'pickup')

        JavaBuildpack::Repository::ConfiguredItem.stub(:find_item) { |&block| block.call(VIRGO_VERSION) if block }
        .and_return(VIRGO_DETAILS)

        JavaBuildpack::Util::ApplicationCache.stub(:new).and_return(application_cache)
        application_cache.stub(:get).with('test-virgo-uri').and_yield(File.open('spec/fixtures/stub-virgo.zip'))

        Virgo.new(
            app_dir: root,
            application: JavaBuildpack::Application.new(root),
            configuration: {}
        ).compile

        virgo_dir = File.join root, '.virgo'

        startup_script = File.join virgo_dir, 'bin', 'startup.sh'
        expect(File.exists?(startup_script)).to be_true

        splash_jar = File.join virgo_dir, 'pickup', 'org.eclipse.virgo.apps.splash_3.6.2.RELEASE.jar'
        expect(File.exists?(splash_jar)).to be_false

        tomcat_server = File.join virgo_dir, 'configuration', 'tomcat-server.xml'
        expected_tomcat_server = File.new(File.join 'resources', 'virgo', 'configuration', 'tomcat-server.xml')
        expect(FileUtils.compare_file(expected_tomcat_server, tomcat_server)).to be_true
      end
    end

    it 'should fail to link additional libs' do
      Dir.mktmpdir do |root|
        lib_directory = File.join(root, '.lib')
        Dir.mkdir lib_directory
        Dir.mkdir File.join root, 'pickup'
        system "cp -r spec/fixtures/framework_spring_insight/.insight/weaver/insight-weaver-1.2.4-CI-SNAPSHOT.jar #{lib_directory}"

        JavaBuildpack::Repository::ConfiguredItem.stub(:find_item) { |&block| block.call(VIRGO_VERSION) if block }
        .and_return(VIRGO_DETAILS)

        JavaBuildpack::Util::ApplicationCache.stub(:new).and_return(application_cache)
        application_cache.stub(:get).with('test-virgo-uri').and_yield(File.open('spec/fixtures/stub-virgo.zip'))

        expect do
          Virgo.new(
              app_dir: root,
              application: JavaBuildpack::Application.new(root),
              configuration: {},
              lib_directory: lib_directory
          ).compile
        end.to raise_error(/Virgo does not have a linear application classpath/)
      end
    end

    it 'should return command' do
      JavaBuildpack::Repository::ConfiguredItem.stub(:find_item) { |&block| block.call(VIRGO_VERSION) if block }
      .and_return(VIRGO_DETAILS)

      command = Virgo.new(
          app_dir: 'spec/fixtures/container_virgo',
          application: JavaBuildpack::Application.new('spec/fixtures/container_virgo'),
          java_home: 'test-java-home',
          java_opts: %w(test-opt-2 test-opt-1 -Djava.io.tmpdir=test),
          configuration: {}
      ).release

      expect(command).to eq('JAVA_HOME=$PWD/test-java-home JAVA_OPTS="-Dhttp.port=$PORT test-opt-1 test-opt-2" .virgo/bin/startup.sh -clean')
    end

  end

end
