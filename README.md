# Eclipse Virgo buildpack

This is a [Cloud Foundry][] buildpack for running [Eclipse Virgo](http://www.eclipse.org/virgo/) applications. It is a fork of the Cloud Foundry [Java Buildpack](https://github.com/cloudfoundry/java-buildpack).

[![Build Status](https://travis-ci.org/glyn/virgo-buildpack.png)](https://travis-ci.org/glyn/virgo-buildpack)

## Usage
To use this buildpack specify the URI of the repository when pushing an application to Cloud Foundry:

    cf push --buildpack https://github.com/glyn/java-buildpack-new

## Overview

The buildpack knows how to detect and launch certain types of applications (described below) in Virgo.

The buildpack is configured by specifying its git URL on the `vmc push` operation, thus:

    vmc push <appname> --buildpack=git://github.com/glyn/virgo-buildpack.git

### Application Types

###Virgo Overlay

The application consists of one or more Virgo artefacts in a directory named `pickup`. Virgo artefacts include WAR files, OSGi Web Application Bundles, plans, and PAR files. See the [Virgo Programmer Guide](http://www.eclipse.org/virgo/documentation/) for more information about these artefact types.

If the artefacts have any dependencies not met by Virgo, the dependency bundles should be stored in a directory named `repository/usr`.

Issue `cf push` from a directory containing a `pickup` directory and, optionally, a `repository/usr` directory. See the `overlay-sample` directory for a trivial example application (with servlet configured at `<URL>/nospring`).

This type of application causes Virgo Server for Apache Tomcat to be launched as the runtime container.

## API

A buildpack supports three operations (via corresponding scripts in the `bin` directory):

* `detect <app directory>`: prints the application type to standard output and exits with status code 0 if and only if the buildpack can handle the application in the specified directory. Does not modify the specified directory.
* `compile <app directory> <cache directory>`: prepares a droplet for launching the application.
* `release <app directory>`: prints launch information and configuration to standard output in YAML format.

## Acknowledgements

The Virgo buildpack was forked from the [CloudFoundry Java buildpack](https://github.com/cloudfoundry/java-buildpack) from which the remaining sections of this documentation derive.

CloudFoundry buildpacks were modelled on [Heroku buildpacks](https://devcenter.heroku.com/articles/buildpacks).

## Configuration and Extension
The buildpack supports configuration and extension through the use of Git repository forking.  The easiest way to accomplish this is to use [GitHub's forking functionality][] to create a copy of this repository.  Make the required configuration and extension changes in the copy of the repository.  Then specify the URL of the new repository when pushing Cloud Foundry applications.  If the modifications are generally applicable to the Cloud Foundry community, please submit a [pull request][] with the changes.

## Additional Documentation
* [Design](docs/design.md)
* [Migrating from the Previous Java Buildpack](docs/migration.md)
* [Security](docs/security.md)
* Standard Containers
	* [Groovy](docs/container-groovy.md) ([Configuration](docs/container-groovy.md#configuration))
	* [Java Main Class](docs/container-java-main.md) ([Configuration](docs/container-java-main.md#configuration))
	* [Play](docs/container-play.md)
	* [Spring Boot CLI](docs/container-spring-boot-cli.md) ([Configuration](docs/container-spring-boot-cli.md#configuration))
	* [Tomcat](docs/container-tomcat.md) ([Configuration](docs/container-tomcat.md#configuration))
	* [Virgo](docs/container-virgo.md) ([Configuration](docs/container-virgo.md#configuration))
* Standard Frameworks
	* [`JAVA_OPTS`](docs/framework-java_opts.md) ([Configuration](docs/framework-java_opts.md#configuration))
	* [AppDynamics](docs/framework-app-dynamics.md) ([Configuration](docs/framework-app-dynamics.md#configuration))
	* [New Relic](docs/framework-new-relic.md) ([Configuration](docs/framework-new-relic.md#configuration))
	* [Play Auto Reconfiguration](docs/framework-play-auto-reconfiguration.md) ([Configuration](docs/framework-play-auto-reconfiguration.md#configuration))
	* [Play JPA Plugin](docs/framework-play-jpa-plugin.md) ([Configuration](docs/framework-play-jpa-plugin.md#configuration))
	* [Spring Auto Reconfiguration](docs/framework-spring-auto-reconfiguration.md) ([Configuration](docs/framework-spring-auto-reconfiguration.md#configuration))
	* [Spring Insight](docs/framework-spring-insight.md) ([Configuration](docs/framework-spring-insight.md#configuration))
* Standard JREs
	* [OpenJDK](docs/jre-openjdk.md) ([Configuration](docs/jre-openjdk.md#configuration))
* [Extending](docs/extending.md)
* Utilities
	* [Caches](docs/util-caches.md) ([Configuration](docs/util-caches.md#configuration))
	* [Logging](docs/logging.md) ([Configuration](docs/logging.md#configuration))
	* [Repositories](docs/util-repositories.md)
	* [Other Utiltities](docs/util-other.md)
	* [Repository Builder](docs/util-repository-builder.md)
	* [Test Applications](docs/util-test-applications.md)
	* [System Tests](docs/util-system-tests.md)

## Running Tests
To run the tests, do the following:

```bash
bundle install
bundle exec rake
```

If you want to use the RubyMine debugger, you may need to [install additional gems][] by issuing:

```bash
bundle install --gemfile Gemfile.rubymine-debug
```

[Installing Cloud Foundry on Vagrant][] is useful for privately testing new features.

## Contributing
[Pull requests][] are welcome; see the [contributor guidelines][] for details.

## License
This buildpack is released under version 2.0 of the [Apache License][].

[Apache License]: http://www.apache.org/licenses/LICENSE-2.0
[Cloud Foundry]: http://www.cloudfoundry.com
[contributor guidelines]: CONTRIBUTING.md
[GitHub's forking functionality]: https://help.github.com/articles/fork-a-repo
[install additional gems]: http://stackoverflow.com/questions/11732715/how-do-i-install-ruby-debug-base19x-on-mountain-lion-for-intellij
[pull request]: https://help.github.com/articles/using-pull-requests
[Pull requests]: http://help.github.com/send-pull-requests
[Installing Cloud Foundry on Vagrant]: http://blog.cloudfoundry.com/2013/06/27/installing-cloud-foundry-on-vagrant/
