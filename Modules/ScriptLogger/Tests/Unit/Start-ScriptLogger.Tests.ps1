
$modulePath = Resolve-Path -Path "$PSScriptRoot\..\..\.." | Select-Object -ExpandProperty Path
$moduleName = Resolve-Path -Path "$PSScriptRoot\..\.." | Get-Item | Select-Object -ExpandProperty BaseName

Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$modulePath\$moduleName" -Force

Describe 'Start-ScriptLogger' {

    Mock Get-Date { return [DateTime]::new(2010, 12, 06, 18, 20, 22) } -ModuleName $moduleName

    $defaultEnabled  = $true
    $defaultPath     = "$PSScriptRoot\Start-ScriptLogger.Tests.ps1.log"
    $defaultFormat   = '{0:yyyy-MM-dd}   {0:HH:mm:ss}   {1}   {2}   {3,-11}   {4}'
    $defaultLevel    = 'Verbose'
    $defaultEncoding = 'UTF8'
    $defaultRotation = 'None'
    $defaultLogFile  = $true
    $defaultEventLog = $true
    $defaultConsole  = $true

    It 'should return default values without any specification' {

        # Act
        $scriptLogger = Start-ScriptLogger -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.Rotation      | Should -Be $defaultRotation
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter path' {

        # Arrange
        $expectedPath = 'TestDrive:\test.log'

        # Act
        $scriptLogger = Start-ScriptLogger -Path $expectedPath -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $expectedPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.Rotation      | Should -Be $defaultRotation
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter format' {

        # Arrange
        $expectedFormat = '{4} {3} {2} {1} {0}'

        # Act
        $scriptLogger = Start-ScriptLogger -Format $expectedFormat -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $expectedFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.Rotation      | Should -Be $defaultRotation
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter log level' {

        # Arrange
        $expectedLevel = 'Error'

        # Act
        $scriptLogger = Start-ScriptLogger -Level $expectedLevel -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $expectedLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.Rotation      | Should -Be $defaultRotation
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter encoding' {

        # Arrange
        $expectedEncoding = 'UTF8'

        # Act
        $scriptLogger = Start-ScriptLogger -Encoding $expectedEncoding -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $expectedEncoding
        $scriptLogger.Rotation      | Should -Be $defaultRotation
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter rotation hourly' {

        # Arrange
        $expectedRotation = 'Hourly'
        $expectedPath     = "$PSScriptRoot\Start-ScriptLogger.Tests.ps1.2010120618.log"

        # Act
        $scriptLogger = Start-ScriptLogger -Rotation $expectedRotation -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $expectedPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.Rotation      | Should -Be $expectedRotation
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }


    It 'should return a valid value for the parameter rotation daily' {

        # Arrange
        $expectedRotation = 'Daily'
        $expectedPath     = "$PSScriptRoot\Start-ScriptLogger.Tests.ps1.20101206.log"

        # Act
        $scriptLogger = Start-ScriptLogger -Rotation $expectedRotation -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $expectedPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.Rotation      | Should -Be $expectedRotation
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter rotation monthly' {

        # Arrange
        $expectedRotation = 'Monthly'
        $expectedPath     = "$PSScriptRoot\Start-ScriptLogger.Tests.ps1.201012.log"

        # Act
        $scriptLogger = Start-ScriptLogger -Rotation $expectedRotation -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $expectedPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.Rotation      | Should -Be $expectedRotation
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter rotation yearly' {

        # Arrange
        $expectedRotation = 'Yearly'
        $expectedPath     = "$PSScriptRoot\Start-ScriptLogger.Tests.ps1.2010.log"

        # Act
        $scriptLogger = Start-ScriptLogger -Rotation $expectedRotation -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $expectedPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.Rotation      | Should -Be $expectedRotation
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter no log file' {

        # Act
        $scriptLogger = Start-ScriptLogger -NoLogFile -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.Rotation      | Should -Be $defaultRotation
        $scriptLogger.LogFile       | Should -Be $false
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter no event log' {

        # Act
        $scriptLogger = Start-ScriptLogger -NoEventLog -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.Rotation      | Should -Be $defaultRotation
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $false
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter no console output' {

        # Act
        $scriptLogger = Start-ScriptLogger -NoConsoleOutput -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.Rotation      | Should -Be $defaultRotation
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $false
    }

    AfterEach {

        Get-ScriptLogger | Remove-Item -Force
        Stop-ScriptLogger
    }
}
