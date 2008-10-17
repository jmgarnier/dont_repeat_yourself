# Install hook code here
require File.dirname(__FILE__) + '/lib/d_r_y_gem_installer'
DRYGemInstaller.install

puts "Please make sure you have java installed:"

puts <<EOF
*** Mac OS X ***

If you are running Mac OS X you can safely skip this step — the system comes with a ready-to-use Java runtime and development environment.

*** Ubuntu ***

If you are running Ubuntu 8.04 "Hardy Heron", the easier way to install the JDK is to run:

sudo apt-get install sun-java6-jdk

*** Other Systems ***

Download Java 6 JDK, install it on your file system and make sure it is in your PATH:
http://www.java.com/en/download/index.jsp

$ java -version
java version "1.6.0"
Java(TM) SE Runtime Environment (build 1.6.0-b105)
Java HotSpot(TM) Server VM (build 1.6.0-b105, mixed mode)
EOF

# TODO Uncomment this when the dry.yml is set up ...
# puts "Copying the default dry.yml configuration file to your config folder"
