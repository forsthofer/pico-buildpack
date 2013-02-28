Virgo Buildpack
===============

A Heroku-style buildpack which supports Eclipse Virgo as a runtime container for CloudFoundry.

[![Build Status](https://travis-ci.org/glyn/virgo-buildpack.png)](https://travis-ci.org/glyn/virgo-buildpack)

CloudFoundry Java Buildpack
===========================

Buildpack plugin for deploying exploded Java WAR files and certain other JVM applications.

Overview
--------

A buildpack knows how to detect and launch certain types of application on behalf of CloudFoundry.

A buildpack is configured by specifying its git URL on the vmc push operation.

API
---

A buildpack supports three operations (via corresponding scripts in the `bin` directory):

* detect <app directory>: exits with status code 0 if and only if the buildpack has a suitable language pack for the application in the specified directory. Does not modify the specified directory.
* compile <app directory> <cache directory>: prepares the application droplet for launching.
* release: returns launch information and configuration in YAML format.

Acknowledgements
----------------

The Virgo buildpack was forked from [CloudFoundry Java buildpack](https://github.com/cloudfoundry/cloudfoundry-buildpack-java).

CloudFoundry buildpacks were modelled on [Heroku buildpacks](https://devcenter.heroku.com/articles/buildpacks).
