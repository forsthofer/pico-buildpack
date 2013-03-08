Virgo Buildpack
===============

A CloudFoundry buildpack which supports Eclipse Virgo as a runtime container.

[![Build Status](https://travis-ci.org/glyn/virgo-buildpack.png)](https://travis-ci.org/glyn/virgo-buildpack)

Overview
--------

A buildpack knows how to detect and launch certain types of application on behalf of CloudFoundry.

A buildpack is configured by specifying its git URL on the `vmc push` operation, thus:

    vmc push <appname> --buildpack=git://github.com/glyn/virgo-buildpack.git

Application Types
-----------------
###Virgo Web

The application is a single unpacked WAR or OSGi Web Application Bundle containing the file `META-INF/MANIFEST.MF`.

Issue `vmc push` from a directory containing the unpacked application. See the `snifftest` directory for a trivial example application.

This type of application causes Virgo Server for Apache Tomcat to be launched as the runtime container.

###Virgo Overlay

The application consists of one or more Virgo artefacts in a directory named `pickup`.
If the artefact has any additional dependencies, these should be stored in a directory named `repository/usr`.

Issue `vmc push` from a directory containing a `pickup` directory and, optionally, a `repository/usr` directory.

This type of application causes Virgo Server for Apache Tomcat to be launched as the runtime container.

API
---

A buildpack supports three operations (via corresponding scripts in the `bin` directory):

* `detect <app directory>`: prints the application type to standard output and exits with status code 0 if and only if the buildpack can handle the application in the specified directory. Does not modify the specified directory.
* `compile <app directory> <cache directory>`: prepares a droplet for launching the application.
* `release <app directory>`: prints launch information and configuration to standard output in YAML format.

Acknowledgements
----------------

The Virgo buildpack was forked from [CloudFoundry Java buildpack](https://github.com/cloudfoundry/cloudfoundry-buildpack-java).

CloudFoundry buildpacks were modelled on [Heroku buildpacks](https://devcenter.heroku.com/articles/buildpacks).
