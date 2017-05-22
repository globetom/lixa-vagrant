# [LIXA](https://sourceforge.net/p/lixa/wiki/Home) + [Vagrant](https://www.vagrantup.com)

[![Website][website-badge]][website-url]
[![Documentation][documentation-badge]][documentation-url]

Vagrant is used to create an isolated development environment for LIXA 
including Postgres and MySQL.

## Starting

> _All of the boxes are CentOS based_

Once you have Vagrant installed, follow those steps:

```bash
# clone the repo
$ git clone https://github.com/globetom/lixa-vagrant.git
$ cd lixa-vagrant

# start the box with the default virtualbox provider
$ vagrant up
# or, start with the parallels provider
$ vagrant up --provider parallels
# or, start with the azure provider
$ vagrant up --provider azure
```

The startup process will install all the dependencies necessary for developing 
and running LIXA inside the Vagrant box.

> **_Make sure to install the relevant provider plugins for Vagrant._**

### Providers

* [VirtualBox](https://www.vagrantup.com/docs/virtualbox)
* [Parallels](https://github.com/Parallels/vagrant-parallels)
* [Azure](https://github.com/Azure/vagrant-azure)

### Environment Variables

You can alter the behavior of the provision step by setting the following 
environment variables:

| name | description | default |
| ---- | ----------- | ------- |
| `LIXA_VB_MEM` | virtual machine memory (RAM) size *(in MB)* | `1024` |
| `LIXA_VB_CPU` | virtual machine cpu (vCPU) number | `2` |
| `LIXA_VERSION` | the LIXA version number to download and install at the provision step | `1.1.1` |
| `LIXA_RUN_TESTS` | indication if the built-in test campaign should be execution after compilation | `false` |

> **_The following are required when using the azure provider_**

| name | description |
| ---- | ----------- |
| `AZURE_TENANT_ID` | your azure active directory tenant id |
| `AZURE_CLIENT_ID` | your azure active directory application client id |
| `AZURE_CLIENT_SECRET` | your azure active directory application client secret |
| `AZURE_SUBSCRIPTION_ID` | the azure subscription id you'd like to use |

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

### Load Testing

Be sure to read the chapter on [tuning](http://lixa.sourceforge.net/lixa-doc/html/ch10.html).

Once you have configured the most appropriate settings for LIXA, run:

```bash
$ for l in 10 20 30 40 50 60 70 80 90 100 ; do /opt/lixa/bin/lixat -b -s -l $l ; done | grep -v '^ ' > /tmp/bench_result.csv
```

[website-badge]: https://img.shields.io/badge/LIXA-Learn%20More-43bf58.svg
[website-url]: https://sourceforge.net/p/lixa/wiki/Home
[documentation-badge]: https://img.shields.io/badge/Documentation-Read%20Online-green.svg
[documentation-url]: http://lixa.sourceforge.net/lixa-doc/html