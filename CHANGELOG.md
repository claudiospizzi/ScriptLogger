# Changelog

All notable changes to this project will be documented in this file.

The format is mainly based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## Unreleased

* Added: Option to include the script stack trace in the error log message (Write-ErrorLog)
* Added: Add caller context information (script name and line number) to the log messages (Start-ScriptLogger)

## 3.3.0 - 2019-11-05

* Added: The parent folder will be created, if it does not exists

## 3.2.0 - 2019-08-29

* Added: The Path parameter for Start-ScriptLogger can now be an empty string

## 3.1.0 - 2019-02-18

* Added: Optional log rotation (hourly, daily, monthly, yearly)

## 3.0.1 - 2019-02-14

* Changed: Format of the script logger object to show the logger name

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
