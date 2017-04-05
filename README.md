# BuildModule
=============

Basic script to create a blank PowerShell module with appveyor integration

## Instructions

```powershell
Prepare parameters for your new Module

$moduleParams  =@{
ModulePath = 'C:\Repo\GIT'
ModuleName = 'SampleModule'
Author = 'Mateusz Czerniawski'
Description = 'Some Description of your SampleModule'
}

Invoke the function with splatting
New-ArcModule @moduleParams


Need to update next:
In file SampleModule.psd1
LicenseUri <-- pointing to your github LICENSE file
PojectUri <-- pointing to your github URI

In file appveyor.yml
NuGetApiKey:
    secure: <-- change to your secure key from AppVeyor
```