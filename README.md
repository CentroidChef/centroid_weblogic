# centroid_weblogic

## Overview

This cookbook installs Oracle WebLogic.

## Installed Software

WebLogic 12c (12.2.1.3.0)
Java 8 (jdk1.8.0_151)

## Current Status: Testing Phase

Adding default domain creation and testing has started.

## Cookbook Description

This cookbook will do the following by default:

  1) Create a /stage folder where all installation media will be downloaded.
  2) Download media from chef-assets server.
  3) Install Java 8 onto the system.
  4) Create "oracle" user and "oinstall" group.
  5) Install Weblogic 12c as a silent install.
  6) Creates a default domain (default_domain)
  7) Starts the default domain.

Steps 6 and 7 are optional.

## TODO

Add test code.

## Cookbook Usage

To be added later.
