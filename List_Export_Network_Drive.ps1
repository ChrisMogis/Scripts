#Declaration des variables
$computer = $env:COMPUTERNAME
$File = "C:\Windows\temp\$computer.csv"
$targetfile = "\\NomduServeur\Share_Name\"

#Remove du fichier existant sur le serveur
rm $targetfile$computer.csv

#Recuperation des informations
$Result1 = (Get-wmiobject Win32_computersystem).PrimaryOwnerName
$Result2 = (Get-wmiobject Win32_computersystem).Name
$Result3 = Get-PSDrive -PSProvider FileSystem | Select-Object Name, DisplayRoot

#Creation du fichier CSV
$Result1 + ";  " + $Result2 + ";  " | Out-File $File -Append
$Result3 | Out-File $File -Append

#Copie du fichier vers le serveur distant
cp $File $targetfile

#Remove du fichier local
rm $File
