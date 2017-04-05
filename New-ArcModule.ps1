function New-ArcModule
{
  <#
      .SYNOPSIS
      Creates scaffolding for new module.

      .DESCRIPTION
      Creates basic module with files downloaded from mczerniawski\BuildModule github repo.

      .EXAMPLE
      $moduleParams  =@{
        ModulePath = 'C:\Repo\GIT'
        ModuleName = 'ArcHyperV'
        Author = 'Mateusz Czerniawski'
        Description = 'Module for basic Hyper-V Management'
      }
      New-ArcModule @moduleParams

      Create a hashtable of parameters and pass create new Module with it.
      
  #>
  [CmdletBinding()]
  [OutputType([void])]
  param
  (
    [Parameter(Mandatory=$true, Position=0,
        ValueFromPipeline = $true,  
    ValueFromPipelineByPropertyName = $true)]
    [ValidateScript({Test-Path $_ -PathType 'Container'})]
    [System.String]
    $ModulePath,
    
    [Parameter(Mandatory=$true, Position=1,
        ValueFromPipeline = $true,  
    ValueFromPipelineByPropertyName = $true)]
    [System.String[]]
    $ModuleName ,
    
    [Parameter(Mandatory=$true, Position=2,
        ValueFromPipeline = $true,  
    ValueFromPipelineByPropertyName = $true)]
    [System.String]
    $Author ,
    
    [Parameter(Mandatory=$true, Position=3,
        ValueFromPipeline = $true,  
    ValueFromPipelineByPropertyName = $true)]
    [System.String]
    $Description 
  )
  
  Begin {
    Write-Verbose -Message "Starting $($MyInvocation.MyCommand) " 
    Write-Verbose -Message 'Execution Metadata:'
    Write-Verbose -Message "User = $($env:userdomain)\$($env:USERNAME)" 
    Write-Verbose -Message "Computername = $env:COMPUTERNAME" 
    Write-Verbose -Message "Host = $($host.Name)"
    Write-Verbose -Message "PSVersion = $($PSVersionTable.PSVersion)"
    Write-Verbose -Message "Runtime = $(Get-Date)" 

    Write-Verbose -Message "[$((get-date).TimeOfDay.ToString()) BEGIN   ] Starting: $($MyInvocation.Mycommand)"
    
  }
  Process{
    foreach ($Module in $ModuleName) {
      Write-Verbose -Message "[$((get-date).TimeOfDay.ToString()) PROCESS ] Processing module {$Module} scaffolding creation."
    
      $newPath = "$ModulePath\$Module"
      Write-Verbose -Message "[$((get-date).TimeOfDay.ToString()) PROCESS ] Creating necessary folders in {$newPath}."
      [void] (New-Item -ItemType Directory -Path  $newPath\$Module -Force)
      [void] (New-Item -ItemType Directory -Path  $newPath\$Module\Private -Force)
      [void] (New-Item -ItemType Directory -Path  $newPath\$Module\Public -Force)
      [void] (New-Item -ItemType Directory -Path  $newPath\$Module\en-US -Force)
      [void] (New-Item -ItemType Directory -Path  $newPath\Tests -Force)
  
      Write-Verbose -Message "[$((get-date).TimeOfDay.ToString()) PROCESS ] Creating necessary module files in {$newPath}."
      [void] (New-Item -Path "$newPath\$Module\$Module.psm1" -ItemType File -Force)
      [void] (New-Item -Path "$newPath\$Module\en-US\about_$Module.help.txt" -ItemType File -Force )
      [void] (New-Item -Path "$newPath\Tests\$Module.Tests.ps1" -ItemType File -Force)
      
      Write-Verbose -Message "[$((get-date).TimeOfDay.ToString()) PROCESS ] Creating new module {$Module} in {$newPath}."
      $params = @{
        Path = "$newPath\$Module\$Module.psd1"
        RootModule ="$newPath\$Module\$Module.psm1" 
        Description =$Description 
        PowerShellVersion ='3.0'
        Author ="$Author" 
        FormatsToProcess= "$Module.Format.ps1xml"
      }
      try { 
        
        New-ModuleManifest @params -ErrorAction Stop -ErrorVariable problems
        Write-Verbose -Message "[$((get-date).TimeOfDay.ToString()) PROCESS ] Created new module {$Module} in {$newPath}."
  
        Write-Verbose -Message "[$((get-date).TimeOfDay.ToString()) PROCESS ] Downloading files from mczerniawski github repo."

        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mczerniawski/BuildModule/master/appveyor.yml" -OutFile "$newPath\appveyor.yml" 
        Write-Verbose -Message "[$((get-date).TimeOfDay.ToString()) PROCESS ] Downloaded file appveyor.yml to {$newPath\appveyor.yml}."
      
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mczerniawski/BuildModule/master/build.ps1" -OutFile "$newPath\build.ps1"
        Write-Verbose -Message "[$((get-date).TimeOfDay.ToString()) PROCESS ] Downloaded file build.ps1 to {$newPath\build.ps1}."
      
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mczerniawski/BuildModule/master/deploy.psdeploy.ps1" -OutFile "$newPath\deploy.psdeploy.ps1"
        Write-Verbose -Message "[$((get-date).TimeOfDay.ToString()) PROCESS ] Downloaded file deploy.psdeploy.ps1 to {$newPath\deploy.psdeploy.ps1}."
      
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mczerniawski/BuildModule/master/psake.ps1" -OutFile "$newPath\psake.ps1"
        Write-Verbose -Message "[$((get-date).TimeOfDay.ToString()) PROCESS ] Downloaded file psake.ps1 to {$newPath\psake.ps1}."
      
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mczerniawski/BuildModule/master/ModuleName.Format.ps1xml" -OutFile "$newPath\$Module\$Module.Format.ps1xml"
        Write-Verbose -Message "[$((get-date).TimeOfDay.ToString()) PROCESS ] Downloaded file ModuleName.Format.ps1xml to {$newPath\$Module\$Module.Format.ps1xml}."
        
        Write-Verbose -Message "[$((get-date).TimeOfDay.ToString()) PROCESS ] Replacing ModuleModule in psd1 file"
        (Get-Content -LiteralPath $params.Path -ReadCount 0 -Raw).Replace("RootModule = '$($params.RootModule)'","RootModule = '$Module.psm1'") | Set-Content -LiteralPath $params.Path
      }
      catch {
        Write-Error $problems 
      }
    }
  }
  End {
    Write-Verbose -Message "[$((get-date).TimeOfDay.ToString()) END     ] Ending: $($MyInvocation.Mycommand)"
    Write-Verbose -Message "Ending $($MyInvocation.MyCommand) " 
  }
}

  


