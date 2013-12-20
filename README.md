# Eclipse Virgo buildpack

This is a [Cloud Foundry][] buildpack for running [Eclipse Virgo](http://www.eclipse.org/virgo/) applications. It is a fork of the Cloud Foundry [Java Buildpack](https://github.com/cloudfoundry/java-buildpack). The buildpack knows how to detect and launch certain types of applications (described below) in Virgo.

[![Build Status](https://travis-ci.org/glyn/virgo-buildpack.png)](https://travis-ci.org/glyn/virgo-buildpack)

## Usage
To use this buildpack specify the URI of the repository when pushing an application to Cloud Foundry:

 ```bash
 cf push --buildpack https://github.com/glyn/virgo-buildpack
 ```

or if using the [`gcf`][] tool:

```bash
gcf push -b https://github.com/glyn/virgo-buildpack
```

## Application Types

Currently only one type of application is supported.

### Virgo Overlay

The application consists of one or more Virgo artefacts in a directory named `pickup`. Virgo artefacts include WAR files, OSGi Web Application Bundles, plans, and PAR files. See the [Virgo Programmer Guide](http://www.eclipse.org/virgo/documentation/) for more information about these artefact types.

If the artefacts have any dependencies not met by Virgo, the dependency bundles should be stored in a directory named `repository/usr`.

Issue `cf push` from a directory containing a `pickup` directory and, optionally, a `repository/usr` directory.

This type of application causes Virgo Server for Apache Tomcat to be launched as the runtime container.

See the `overlay-sample` directory for a trivial example application. You can push this as follows:

    cd overlay-sample
    cf push

The push uses the settings in `manifest.yml`. The servlet appears at `<application URL>/nospring`. Note that the "Admin Console" link will be broken since the admin console is deleted by the buildpack for security reasons.

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

To learn how to configure various properties of the buildpack, follow the "Configuration" links below. More information on extending the buildpack is available [here](docs/extending.md).

## Additional Documentation
* [Design](docs/design.md)
* [Security](docs/security.md)
* Standard Containers
	* [Groovy](docs/container-groovy.md) ([Configuration](docs/container-groovy.md#configuration))
	* [Java Main](docs/container-java_main.md) ([Configuration](docs/container-java_main.md#configuration))
	* [Play Framework](docs/container-play_framework.md)
	* [Spring Boot CLI](docs/container-spring_boot_cli.md) ([Configuration](docs/container-spring_boot_cli.md#configuration))
	* [Tomcat](docs/container-tomcat.md) ([Configuration](docs/container-tomcat.md#configuration))
	* [Virgo](docs/container-virgo.md) ([Configuration](docs/container-virgo.md#configuration))
* Standard Frameworks
	* [AppDynamics Agent](docs/framework-app_dynamics_agent.md) ([Configuration](docs/framework-app_dynamics_agent.md#configuration))
	* [Java Options](docs/framework-java_opts.md) ([Configuration](docs/framework-java_opts.md#configuration))
	* [MariaDB JDBC](docs/framework-maria_db_jdbc.md) ([Configuration](docs/framework-maria_db_jdbc.md#configuration))
	* [New Relic Agent](docs/framework-new_relic_agent.md) ([Configuration](docs/framework-new_relic_agent.md#configuration))
	* [Play Framework Auto Reconfiguration](docs/framework-play_framework_auto_reconfiguration.md) ([Configuration](docs/framework-play_framework_auto_reconfiguration.md#configuration))
	* [Play Framework JPA Plugin](docs/framework-play_framework_jpa_plugin.md) ([Configuration](docs/framework-play_framework_jpa_plugin.md#configuration))
	* [PostgreSQL JDBC](docs/framework-postgresql_jdbc.md) ([Configuration](docs/framework-postgresql_jdbc.md#configuration))
	* [Spring Auto Reconfiguration](docs/framework-spring_auto_reconfiguration.md) ([Configuration](docs/framework-spring_auto_reconfiguration.md#configuration))
	* [Spring Insight](docs/framework-spring_insight.md)
* Standard JREs
	* [OpenJDK](docs/jre-open_jdk.md) ([Configuration](docs/jre-open_jdk.md#configuration))
* [Extending](docs/extending.md)
	* [Application](docs/extending-application.md)
	* [Droplet](docs/extending-droplet.md)
	* [BaseComponent](docs/extending-base_component.md)
	* [VersionedDependencyComponent](docs/extending-versioned_dependency_component.md)
	* [Caches](docs/extending-caches.md) ([Configuration](docs/extending-caches.md#configuration))
	* [Logging](docs/extending-logging.md) ([Configuration](docs/extending-logging.md#configuration))
	* [Repositories](docs/extending-repositories.md) ([Configuration](docs/extending-repositories.md#configuration))
	* [Utiltities](docs/extending-utiltities.md)
* Related Projects
	* [Java Buildpack Dependency Builder](https://github.com/cloudfoundry/java-buildpack-dependency-builder)
	* [Java Test Applications](https://github.com/cloudfoundry/java-test-applications)
	* [Java Buildpack System Tests](https://github.com/cloudfoundry/java-buildpack-system-test)

## Running Tests
To run the tests, do the following:

```bash
bundle install
bundle exec rake
```

[Installing Cloud Foundry on Vagrant][] is useful for privately testing new features.

## Contributing
[Pull requests][] are welcome; see the [contributor guidelines][] for details.

## License
This buildpack is released under version 2.0 of the [Apache License][].

[Apache License]: http://www.apache.org/licenses/LICENSE-2.0
[Cloud Foundry]: http://www.cloudfoundry.com
[contributor guidelines]: CONTRIBUTING.md
[`gcf`]: https://github.com/cloudfoundry/cli
[GitHub's forking functionality]: https://help.github.com/articles/fork-a-repo
[pull request]: https://help.github.com/articles/using-pull-requests
[Pull requests]: http://help.github.com/send-pull-requests
[Installing Cloud Foundry on Vagrant]: http://blog.cloudfoundry.com/2013/06/27/installing-cloud-foundry-on-vagrant/
