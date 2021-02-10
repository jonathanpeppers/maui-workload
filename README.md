# maui-workload

Prototype of a [dotnet/maui][maui] "workload".

Explanation of projects:

* `Maui.Toolchain` - creates a .NET 6 installation in `~\maui-toolchain\dotnet\`
* `Maui.Dependencies` - installs the Android/iOS workloads & SDK packs
* `Microsoft.NET.Workload.Maui` - configures Maui as a "workload"
* `Microsoft.Maui.Sdk` - Maui's SDK pack

[maui]: https://github.com/dotnet/maui
