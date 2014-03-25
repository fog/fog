# Installing Ruby Fog Bindings for HP Cloud Services

Before you can begin working with the Ruby Fog bindings, you have to install them (of course!). This page provides you with the installation information for the following operating systems:

* [Ubuntu Installation](#ubuntu-installation)
* [Mac OSX Installation](#mac-osx-installation)
* [CentOS Installation](#centos-installation)
* [Uninstalling](#uninstalling)

To install and use HP Cloud Ruby bindings for Fog, please install the [latest release](http://fog.io) of Fog.


## Ubuntu Installation

If you plan on using the Ruby Fog binding on Ubuntu, we recommend you use Ubuntu versions 12.04 or 12.10.  The Ruby Fog bindings may work on other versions, but are not supported.

To install the Ruby Fog bindings on the Ubuntu operating system, follow these steps while logged in as the root user:

1. Install Ruby and Ruby-dev:

        apt-get install ruby1.8 ruby-dev

2. Install RubyGems:

        apt-get install rubygems

3. Install the dependent libraries:

        apt-get install libxml2 libxml2-dev libxslt1-dev libxslt1.1 sgml-base xml-core

4. Install the RDoc Ruby source documenation generator package:

        gem install rdoc

5. Install the Fog gem:

        gem install fog


See the [Connecting to the Service](https://github.com/fog/fog/blob/master/lib/fog/hp/docs/connect.md) page for details on how to connect.

## MacOS X Installation

Some Ruby packages require C/C++ compiler support.  On the MacOS, if you haven't already installed XCode, we recommend that you install it to provide the needed C/C++ compiler for your system.

To install the Ruby Fog bindings on MacOS X, follow these steps while logged in as the root user:

1. Download and install Xcode.  You can [download the most recent version of XCode through the Mac App Store](https://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12).  If you want to install an earlier version of Xcode, go to the [Apple Developer](https://developer.apple.com/downloads/index.action) site and search for "Xcode".  In the results list, select the version of Xcode that you want and install it.  (Note that you need to be signed up as an "Apple Developer" to access the download.  Sign-up is free.)

2. To make your installation process easier we recommend that you install [Homebrew](http://wiki.github.com/mxcl/homebrew/installation).  Follow the instructions on the Homebrew page to install the package.  After you have downloaded Homebrew, the CLI command to install it is:

        homebrew install - ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"

3. Add the Homebrew path to your $PATH environment variable.  You can either do this via the CLI command line:

        export PATH=:/usr/local/sbin:$PATH

    (The default Homebrew installation location is the `/usr/local/sbin` directory.)  Or you can add the Homebrew path (`/usr/local/sbin`) to your $PATH environment variable in your local `.profile` file.

4. Install RVM on your system:

        curl -L get.rvm.io | bash -s stable

    **Note**: You can also install RVM using [Jewelry Box](https://unfiniti.com/software/mac/jewelrybox), a RVM graphical user interface (GUI) for Mac OSX.

5. Install the packages required by RVM; the following command lists the required packages:

        source ~/.rvm/scripts/rvm
        rvm requirements # install required packages

6. Install the required packages listed in Step 5:

        brew install <packages>

    Where `<packages>` are the packages that you need to install.

7. Install the `libksba` library:

        brew install libksba

8. Install Ruby:

        rvm user all
        rvm install ruby-1.9.2 --with-gcc=clang

9. Use the Ruby version and make it the default:

        rvm use 1.9.2 --default

10. Install the Fog gem:

        gem install fog


See the [Connecting to the Service](https://github.com/fog/fog/blob/master/lib/fog/hp/docs/connect.md) page for details on how to connect.

## CentOS Installation

If you plan on using the Ruby Fog binding on CentOS, we recommend you use CentOS versions 6.2 or 6.3.  The Ruby Fog bindings may work on other versions, but are not supported.

To install the Ruby Fog bindings on CentOS, follow these steps while logged in as the root user:

1. Install Ruby and Ruby Dev:

        yum install -y ruby ruby-devel

2. Install Rubygems:

        yum install -y rubygems

3. Install the dependent libraries:

        yum install -y gcc make libxml2 libxml2-devel libxslt libxslt-devel

4. Install RDoc Ruby source documentation generator package:

        gem install rdoc

5. Install the Fog gem:

        gem install fog


See the [Connecting to the Service](https://github.com/fog/fog/blob/master/lib/fog/hp/docs/connect.md) page for details on how to connect.

## Uninstalling

Its recommended that you uninstall a previous version prior to upgrading. To uninstall, execute the followin command while logged in as the root user:

        gem uninstall fog

---------
[Documentation Home](https://github.com/fog/fog/blob/master/lib/fog/hp/README.md) | [Examples](https://github.com/fog/fog/blob/master/lib/fog/hp/examples/getting_started_examples.md)
