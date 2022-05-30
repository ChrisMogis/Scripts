Param(
[Parameter(Mandatory=$true)]
[ValidateSet("Install", "Uninstall")]
[String[]]
$Choose
)

If ($Choose -eq "Install")
  {
  DISM /Online /Enable-Feature /FeatureName:NetFx3 /All
  }

If  ($Choose -eq "Uninstall")
  {
  Disable-WindowsOptionalFeature -Online -FeatureName 'NetFx3' -Remove -NoRestart
  }
