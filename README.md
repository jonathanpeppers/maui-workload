# maui-workload

Prototype of a [dotnet/maui][maui] "workload". Go to
[dotnet/maui][maui] if you are looking for Maui itself.

Explanation of projects:

* `DotNet.Toolchain` - creates a .NET 6 installation in `bin`
* `Maui.Dependencies` - installs the Android/iOS workloads & SDK packs
* `Microsoft.NET.Workload.Maui` - configures Maui as a "workload"
* `Microsoft.Maui.Sdk` - Maui's SDK pack

This prototype, enables a project to be able to set `$(UseMaui)`:

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net6.0-android</TargetFramework>
    <OutputType>Exe</OutputType>
    <UseMaui>true</UseMaui>
  </PropertyGroup>
</Project>
```

This automatically brings in:

* `Microsoft.NET.Workload.Maui`
* `Microsoft.Maui.Sdk`

Where the SDK sets up stable Xamarin.Forms 4.8.0.1364 in a .NET 6 project.

Special files:

* `AutoImport.props` - defines the default includes (or wildcards) for
  Maui projects will go. Note that this is imported by *all* .NET 6
  project types -- *even non-mobile ones*.
* `WorkloadManifest.json` - general .NET workload configuration
* `WorkloadManifest.targets` - imports `Microsoft.Maui.Sdk` when
  `$(UseMaui)` is `true`. Note that this is imported by *all* .NET 6
  project types -- *even non-mobile ones*.

For further details about .NET Workloads, see these .NET design docs:

* [.NET Optional SDK Workloads](https://github.com/dotnet/designs/blob/main/accepted/2020/workloads/workloads.md)
* [Workload Resolvers](https://github.com/dotnet/designs/blob/main/accepted/2020/workloads/workload-resolvers.md)
* [Workload Manifests](https://github.com/dotnet/designs/pull/120/files)

## Building

To build this repo:

```bash
dotnet build
```

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

```bash
./bin/dotnet/dotnet build samples/samples.sln
```

*TODO: iOS is not working yet.*

## TODO: How to use IDEs?

The Xamarin.Forms/MAUI team is probably quite accustomed to using
IDEs. Since we have to completely bootstrap a `dotnet` installation in
`bin/dotnet/`, it becomes *complicated* on how we actually use a local
build in IDEs.

I'm thinking we could make symbolic links:

* `%ProgramFiles%\dotnet\` -> `.\bin\dotnet\`
* `/usr/local/share/dotnet/` -> `./bin/dotnet/`

Would need to test if this would *actually* work, or if there is a way
to tell IDEs where `dotnet` installs are located.

[maui]: https://github.com/dotnet/maui
