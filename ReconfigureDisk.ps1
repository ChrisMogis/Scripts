$ExtraDrive = Get-WmiObject win32_logicaldisk -Filter "DeviceID ='D:'"

if ($ExtraDrive.DeviceID -eq 'D:') {
    #xcopy $ExtraDrive.DeviceID c:\ /s /y > $env:temp\DataCopy.log
    $DriveLetter = $ExtraDrive.DeviceID.Trim(":")
    Remove-Partition -DriveLetter $DriveLetter -Confirm:$false
    $MaxSize = (Get-PartitionSupportedSize -DriveLetter C).sizeMax
    Resize-Partition -DriveLetter C -Size $MaxSize
}

else { write-host "No drive with that letter exists"
}
