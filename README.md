# [LIXA](https://sourceforge.net/p/lixa/wiki/Home) + [Vagrant](https://www.vagrantup.com)

[![Website][website-badge]][website-url]
[![Documentation][documentation-badge]][documentation-url]

Vagrant is used to create an isolated development environment for LIXA 
including Postgres and MySQL.

## Starting

Once you have Vagrant installed, follow those steps:

```bash
# clone the repo
$ git clone https://github.com/tiian/lixa-vagrant.git
$ cd lixa-vagrant

# start the box with the default virtualbox provider
$ vagrant up
# or, start with the parallels provider
$ vagrant up --provider parallels
```

> _Both of the boxes are CentOS based._

The startup process will install all the dependencies necessary for developing 
and running LIXA inside the Vagrant box.

### Environment Variables

You can alter the behavior of the provision step by setting the following 
environment variables:

| name | description | default |
| ---- | ----------- | ------- |
| `LIXA_VB_MEM` | virtual machine memory (RAM) size *(in MB)* | `1024` |
| `LIXA_VB_CPU` | virtual machine cpu (vCPU) number | `2` |
| `LIXA_VERSION` | the LIXA version number to download and install at the provision step | `1.1.1` |
| `LIXA_RUN_TESTS` | indication if the built-in test campaign should be execution after compilation | `false` |

Use them when provisioning, e.g.:
```bash
$ LIXA_VERSION=1.3.4 LIXA_RUN_TESTS=true vagrant up
# or
$ LIXA_VERSION=1.3.4 LIXA_RUN_TESTS=true vagrant provision
```

## Building and Running LIXA

LIXA will be compiled during provisioning but if you want to re-compile, execute
the following commands:

```bash
# SSH into the vagrant box
$ vagrant ssh

# navigate to the lixa source folder
$ cd lixa-${LIXA_VERSION}

# compile
$ make
```

To run LIXA:

```bash
# SSH into the vagrant box, if you are not already
$ vagrant ssh

# start LIXA
$ sudo /opt/lixa/sbin/lixad -d
```

## Testing LIXA

The LIXA test campaign will be executed during provisioning if the `LIXA_RUN_TESTS`
environment variable was set to `true`, or:

```bash
# SSH into the vagrant box
$ vagrant ssh

# navigate to the lixa source folder
$ cd lixa-${LIXA_VERSION}

# test
$ make check
```

[website-badge]: https://img.shields.io/badge/lixa-Learn%20More-43bf58.svg
[website-url]: https://sourceforge.net/p/lixa/wiki/Home
[documentation-badge]: https://img.shields.io/badge/Documentation-Read%20Online-green.svg
[documentation-url]: http://lixa.sourceforge.net/lixa-doc/html