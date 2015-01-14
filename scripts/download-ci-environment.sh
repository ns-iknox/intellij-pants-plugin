#!/usr/bin/env bash

set -e

CWD=$(pwd)

SCALA_PLUGIN_ID="org.intellij.scala"
PYTHON_CE_PLUGIN_ID="PythonCore"

mkdir -p .cache/intellij

if [ ! -d .cache/intellij/ideaIC ]; then
  echo "Loading IntelliJ Community Edition $IJ_VERSION..."
  wget http://download-cf.jetbrains.com/idea/ideaIC-${IJ_VERSION}.tar.gz
  tar zxf ideaIC-${IJ_VERSION}.tar.gz
  rm -rf ideaIC-${IJ_VERSION}.tar.gz
  UNPACKED_IDEA=$(find . -name 'idea-IC*' | head -n 1)
  mv "$UNPACKED_IDEA" ".cache/intellij/ideaIC"
fi

if [ ! -d .cache/intellij/plugins ]; then
  echo "Loading $SCALA_PLUGIN_ID and $PYTHON_CE_PLUGIN_ID for $IJ_BUILD..."
  mkdir -p plugins
  pushd plugins

  wget -O Scala.zip "https://plugins.jetbrains.com/pluginManager/?action=download&id=$SCALA_PLUGIN_ID&build=$IJ_BUILD"
  unzip Scala.zip
  rm -rf Scala.zip
  wget -O python.zip "https://plugins.jetbrains.com/pluginManager/?action=download&id=$PYTHON_CE_PLUGIN_ID&build=$IJ_BUILD"
  unzip python.zip
  rm -rf python.zip

  popd
  mv plugins ".cache/intellij/plugins"
fi

if [ ! -d .cache/intellij/pants ]; then
  echo "Getting latest Pants..."
  pushd .cache/intellij/
  git clone https://github.com/pantsbuild/pants
  popd
fi

