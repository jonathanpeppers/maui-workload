# maui-workload

Prototype of a [dotnet/maui][maui] "workload".

Explanation of projects:

* `DotNet.Toolchain` - creates a .NET 6 installation in `bin`
* `Maui.Dependencies` - installs the Android/iOS workloads & SDK packs
* `Microsoft.NET.Workload.Maui` - configures Maui as a "workload"
* `Microsoft.Maui.Sdk` - Maui's SDK pack

## Building

To build this repo:

    dotnet build

This creates the output structure:

* `bin/`
  * `dotnet-install.sh|ps1`
  * `*.nupkg` - any NuGet packages
  * `*.binlog` - any build logs
  * `dotnet/`
    * `dotnet(.exe)`
    * `sdk-manifests/`
      * `6.0.100/`
        * `Microsoft.NET.Workload.Android`
        * `Microsoft.NET.Workload.iOS`
        * `Microsoft.NET.Workload.Maui`
    * `packs`
      * `Microsoft.Android.Ref`
      * `Microsoft.Android.Sdk.host-rid`
      * `Microsoft.iOS.Ref`
      * `Microsoft.iOS.Sdk`
      * `Microsoft.Maui.Sdk`

Next, you can build the `samples` using the local `dotnet`:

    ./bin/dotnet build samples/samples.sln

_TODO: iOS is not working yet_

## TODO: How to use IDEs?

I'm thinking we could make symbolic links:

* `%ProgramFiles%\dotnet\` -> `.\bin\dotnet\`
* `/usr/local/share/dotnet/` -> `./bin/dotnet/`

Would need to test if this would *actually* work, or if there is a way
to tell IDEs where `dotnet` installs are located.

[maui]: https://github.com/dotnet/maui
