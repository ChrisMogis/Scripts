$keyW10 = (Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey
cscript c:\Windows\System32\slmgr.vbs -ipk $keyW10
cscript c:\Windows\System32\slmgr.vbs -ato
