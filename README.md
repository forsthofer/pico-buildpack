Virgo Buildpack
===============

A Heroku-style buildpack which supports Eclipse Virgo as a runtime container for CloudFoundry.

[![Build Status](https://travis-ci.org/glyn/virgo-buildpack.png)](https://travis-ci.org/glyn/virgo-buildpack)

Acknowledgements
----------------

CloudFoundry buildpacks were modeled on [Heroku buildpacks](https://devcenter.heroku.com/articles/buildpacks).

The Virgo buildpack was based on the [CloudFoundry Java buildpack](https://github.com/cloudfoundry/cloudfoundry-buildpack-java)
which is described below.

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

# detect <app directory>: exits with status code 0 if and only if the buildpack has a suitable
language pack for the application in the specified directory. Does not modify the specified directory.
# compile <app directory> <cache directory>: prepares the application for launching.
# release: returns launch information and configuration in YAML format.


Language Packs
--------------

The Java buildpack consists of a series of so-called *language packs*, each of which knows how to detect and launch a specify
type of application. The buildpack searches the language packs in order until it finds one which can handle the
application, otherwise the buildpack gives up and is unable to handle the application.

* Play - support for web apps written to the [Play framework](http://www.playframework.com/)
* Grails - a specialisation of the Spring language pack for [Grails](http://grails.org/) web apps
* Spring - a specialisation of the JavaWeb language pack for web apps written to the
[Spring framework](http://www.springsource.org/spring-framework)
* JavaWeb - support for traditional Java web apps