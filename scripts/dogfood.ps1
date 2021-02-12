<#
  .SYNOPSIS
  *Windows-only* Launches Visual Studio with environment variables to use the local ./bin/dotnet/dotnet.exe.

  .DESCRIPTION
  *Windows-only* Launches Visual Studio with environment variables to use the local ./bin/dotnet/dotnet.exe.
  Script based on:
  https://github.com/dotnet/runtime/blob/1be117d8e7c0cd29ebc55cbcff2a7fa70604ed39/eng/build.ps1#L186-L208
  https://github.com/dotnet/runtime/blob/1be117d8e7c0cd29ebc55cbcff2a7fa70604ed39/eng/common/tools.ps1#L109

  .PARAMETER vs
  The path to Visual Studio, defaults to:
  "C:\Program Files (x86)\Microsoft Visual Studio\2019\Preview\Common7\IDE\devenv.exe".

  .PARAMETER sln
  The path to a .sln or .project file, defaults to ".\samples\samples.sln".

  .PARAMETER modify
  Modify the environment variables in the current session. This would
  allow the "dotnet" command to work instead of ".\bin\dotnet\dotnet".
  However, it would be good to do this in a new terminal session,
  since you would have trouble running "dotnet build" if it needs to
  provision .NET 6 and the iOS/Android workloads again.

  .EXAMPLE
  PS> .\scripts\dogfood.ps1

  .EXAMPLE
  PS> .\scripts\dogfood.ps1 -vs "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\devenv.exe"

  .EXAMPLE
  PS> .\scripts\dogfood.ps1 -sln .\path\to\MySolution.sln
#>

param(
  [string]$vs = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Preview\Common7\IDE\devenv.exe",
  [string]$sln,
  [switch]$modify
)

$scripts=Split-Path -Parent $MyInvocation.MyCommand.Path
$dotnet=Join-Path $scripts ../bin/dotnet/
$dotnet=(Get-Item $dotnet).FullName

if (-Not $sln) {
    $sln=Join-Path $scripts ../samples/samples.sln
    $sln=(Get-Item $sln).FullName
}

# NOTE: I've not found a better way to do this
# see: https://github.com/PowerShell/PowerShell/issues/3316
$oldDOTNET_INSTALL_DIR=$env:DOTNET_INSTALL_DIR
$oldDOTNET_ROOT=$env:DOTNET_ROOT
$oldDOTNET_MSBUILD_SDK_RESOLVER_CLI_DIR=$env:DOTNET_MSBUILD_SDK_RESOLVER_CLI_DIR
$oldDOTNET_MULTILEVEL_LOOKUP=$env:DOTNET_MULTILEVEL_LOOKUP
$oldDOTNET_SKIP_FIRST_TIME_EXPERIENCE=$env:DOTNET_SKIP_FIRST_TIME_EXPERIENCE
$oldPATH=$env:PATH

try {
    $env:DOTNET_INSTALL_DIR=$dotnet

    # This tells .NET Core to use the bootstrapped runtime
    $env:DOTNET_ROOT=$env:DOTNET_INSTALL_DIR

    # This tells MSBuild to load the SDK from the directory of the bootstrapped SDK
    $env:DOTNET_MSBUILD_SDK_RESOLVER_CLI_DIR=$env:DOTNET_ROOT

    # This tells .NET Core not to go looking for .NET Core in other places
    $env:DOTNET_MULTILEVEL_LOOKUP=0

    # Disable first run since we do not need all ASP.NET packages restored.
    $env:DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1

    # Put our local dotnet.exe on PATH first so Visual Studio knows which one to use
    $env:PATH=($env:DOTNET_ROOT + ";" + $env:PATH)

    # Launch VS
    & "$vs" "$sln"
} finally {
    if (-Not $modify) {
        $env:DOTNET_INSTALL_DIR = $oldDOTNET_INSTALL_DIR
        $env:DOTNET_ROOT=$oldDOTNET_ROOT
        $env:DOTNET_MSBUILD_SDK_RESOLVER_CLI_DIR=$oldDOTNET_MSBUILD_SDK_RESOLVER_CLI_DIR
        $env:DOTNET_MULTILEVEL_LOOKUP=$oldDOTNET_MULTILEVEL_LOOKUP
        $env:DOTNET_SKIP_FIRST_TIME_EXPERIENCE=$oldDOTNET_SKIP_FIRST_TIME_EXPERIENCE
        $env:PATH=$oldPATH
    }
}

exit 0