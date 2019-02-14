# Changelog

All notable changes to this project will be documented in this file.

The format is mainly based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).


## 3.0.0 - 2019-02-14

* Added: Support multiple messages for log functions
* Changed: Support multiple loggers distinguished by a logger name
* Changed: Default log file is now next to the executed script


## 2.0.0 - 2016-12-10

* Changed: Remove positional parameters (BREAKING CHANGE)
* Changed: Convert module to new deployment model
* Changed: Rework code against high quality module guidelines by Microsoft


## 1.2.0 - 2016-03-10

* Added: Encoding option for the log file output
* Added: Error handling for log file and event log output
* Changed: Console output from cmdlets to $Host.UI methods
* Fixed: Error record handling to log correct invocation information


## 1.1.1 - 2016-02-09

* Added: Formats and types resources
* Fixed: Tests for PowerShell 3.0 & 4.0


## 1.1.0 - 2016-02-04

* Added: ErrorRecord parameter to Write-ErrorLog
* Changed: Return logger object inside Start-ScriptLogger


## 1.0.0 - 2016-02-03

* Added: Initial public release
