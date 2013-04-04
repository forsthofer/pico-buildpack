Virgo Buildpack
===============

A CloudFoundry buildpack which supports [Eclipse Virgo](http://www.eclipse.org/virgo/) as a runtime container.

[![Build Status](https://travis-ci.org/glyn/virgo-buildpack.png)](https://travis-ci.org/glyn/virgo-buildpack)

Overview
--------

The buildpack knows how to detect and launch certain types of applications (described below) in Virgo.

The buildpack is configured by specifying its git URL on the `vmc push` operation, thus:

    vmc push <appname> --buildpack=git://github.com/glyn/virgo-buildpack.git

Application Types
-----------------
###Virgo Web

The application is a single web application and is detected by the presence of the file `META-INF/MANIFEST.MF`. The application may be a conventional WAR file or an OSGi Web Application Bundle.

Issue `vmc push` from a directory containing the unpacked web application. See the `snifftest` directory for a trivial example application.

This type of application causes Virgo Server for Apache Tomcat to be launched as the runtime container. [Issue 2](https://github.com/glyn/virgo-buildpack/issues/1) covers launching Virgo Nano Web instead.

###Virgo Overlay

The application consists of one or more Virgo artefacts in a directory named `pickup`. Virgo artefacts include WAR files, OSGi Web Application Bundles, plans, and PAR files. See the [Virgo Programmer Guide](http://www.eclipse.org/virgo/documentation/) for more information about these artefact types.

If the artefacts have any dependencies not met by Virgo, the dependency bundles should be stored in a directory named `repository/usr`.

Issue `vmc push` from a directory containing a `pickup` directory and, optionally, a `repository/usr` directory. See the `overlay-sample` directory for a trivial example application.

This type of application causes Virgo Server for Apache Tomcat to be launched as the runtime container.

API
---

A buildpack supports three operations (via corresponding scripts in the `bin` directory):

* `detect <app directory>`: prints the application type to standard output and exits with status code 0 if and only if the buildpack can handle the application in the specified directory. Does not modify the specified directory.
* `compile <app directory> <cache directory>`: prepares a droplet for launching the application.
* `release <app directory>`: prints launch information and configuration to standard output in YAML format.

Acknowledgements
----------------

The Virgo buildpack was forked from the [CloudFoundry Java buildpack](https://github.com/cloudfoundry/cloudfoundry-buildpack-java).

CloudFoundry buildpacks were modelled on [Heroku buildpacks](https://devcenter.heroku.com/articles/buildpacks).
