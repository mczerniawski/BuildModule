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

```