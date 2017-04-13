# BuildModule
=============

Basic script to create a blank PowerShell module with appveyor integration

## Instructions

```powershell
Prepare parameters for your new Module

 $moduleParams  =@{
        ModulePath = 'C:\Repo\GIT'
        ModuleName = 'SomeModule'
        Author = 'Mateusz Czerniawski'
        Description = 'Module for basic Management'
        ModuleVersion = '1.0.1'
        LicenseUri = 'https://github.com/mczerniawski/SomeModule/blob/master/LICENSE'
        ProjectUri = 'https://github.com/mczerniawski/SomeModule/'
      }

Invoke the function with splatting
New-ArcModule @moduleParams


In file appveyor.yml
NuGetApiKey:
    secure: <-- change to your secure key from AppVeyor
```