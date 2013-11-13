# Virgo Container
The Virgo Container allows one or more Virgo applications to be run. These applications are placed in Virgo's `pickup` directory so that they are automatically deployed when Virgo starts.

The simplest Virgo application is a single [OSGi](http://www.osgi.org/Main/HomePage) bundle.

Place applications in a `pickup` directory of the application directory and push the application directory to Cloud Foundry specifying the Virgo buildpack.

<table>
  <tr>
    <td><strong>Detection Criterion</strong></td><td>Existence of a <tt>pickup</tt> directory in the application directory</td>
  </tr>
  <tr>
    <td><strong>Tags</strong></td><td><tt>virgo=&lang;version&rang;</tt></td>
  </tr>
</table>
Tags are printed to standard output by the buildpack detect script

## Configuration
For general information on configuring the buildpack, refer to [Configuration and Extension][].

The container can be configured by modifying the [`config/virgo.yml`][] file.  The container uses the [`Repository` utility support][repositories] and so it supports the [version syntax][] defined there.

| Name | Description
| ---- | -----------
| `repository_root` | The URL of the Virgo repository index ([details][repositories]).
| `version` | The version of Virgo to use. Candidate versions can be found in [this listing][].

[Configuration and Extension]: ../README.md#Configuration-and-Extension
[`config/virgo.yml`]: ../config/virgo.yml
[repositories]: util-repositories.md
[this listing]: http://virgo.eclipse.org.s3.amazonaws.com/index.yml
[version syntax]: util-repositories.md#version-syntax-and-ordering
