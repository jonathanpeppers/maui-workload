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

[maui]: https://github.com/dotnet/maui

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

## Using IDEs

Currently, you can use Visual Studio 2019 16.9 Preview 4 on Windows
(with the Xamarin workload) with a few manual steps.

### Step 1: Enable Workloads

This is the same setup instructions from the
[net6-mobile-samples][net6-mobile-samples-ides].

Open an Administrator command prompt to enable the
`EnableWorkloadResolver.sentinel` feature flag:

```cmd
> cd "C:\Program Files (x86)\Microsoft Visual Studio\2019\Preview\MSBuild\Current\Bin\SdkResolvers\Microsoft.DotNet.MSBuildSdkResolver"
> echo > EnableWorkloadResolver.sentinel
```

> NOTE: your path to Visual Studio may vary, depending on where you
> selected to install it. `Preview` is the default folder for Visual
> Studio Preview versions.

Restart Visual Studio after making this change.

[net6-mobile-samples-ides]: https://github.com/dotnet/net6-mobile-samples#using-ides

### Step 2: Use your local build-tree

If you just opened `samples/samples.sln` yourself, it would use your
system `dotnet` install such as `%ProgramFiles%\dotnet\` or
`/usr/local/share/dotnet/`.

Instead, use this script at a powershell prompt:

```powershell
.\scripts\dogfood.ps1
```

By default this launches `C:\Program Files (x86)\Microsoft Visual
Studio\2019\Preview\Common7\IDE\devenv.exe` with environment variables
configured to use the local `./bin/dotnet` folder.

You can configure the path to VS with:

```powershell
.\scripts\dogfood.ps1 -vs "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\devenv.exe"
```

Or open a different `.sln` file:

```powershell
.\scripts\dogfood.ps1 -sln .\path\to\YourSolution.sln
```
