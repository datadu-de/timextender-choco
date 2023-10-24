
$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://ftp-2.hostedftp.com/~timextender/TimeXtender+SaaS/TimeXtender.zip'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'MSI'
  url            = $url

  softwareName   = 'TimeXtender [0-9][0-9][0-9][0-9]*'

  checksum       = '4DB584BFB0E230E58CB357684E719FE1D8B5CE83D9AD433DEEE5BF6D4BF1F267'
  checksumType   = 'sha256'

  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes = @(0, 3010, 1641)
}

$zipPath = Get-ChocolateyWebFile -PackageName $env:ChocolateyPackageName -FileFullPath "$toolsDir\TimeXtender.zip" -Url $url

Get-ChocolateyUnzip -FileFullPath $zipPath -Destination $toolsDir

$msiPath = Get-ChildItem -Path $toolsDir -Filter "TimeXtender*.msi" | Sort-Object | Select-Object -Last 1

Install-ChocolateyInstallPackage -PackageName $env:ChocolateyPackageName -FileType $packageArgs.fileType -SilentArgs $packageArgs.silentArgs -File $msiPath.FullName
