﻿#Script Parameters
Param(
[Parameter(Mandatory=$true)]
[ValidateSet("Reboot", "Shutdown")]
[String[]]
$Option
)

#Function create Log folder
    Function CreateLogsFolder
{
    If(!(Test-Path C:\Logs))
    {
    New-Item -Force -Path "C:\Logs\" -ItemType Directory
		}
		else 
		{ 
    Write-Host "The folder "C:\Logs\" already exists !"
    }
}

#Create Log Folder
    CreateLogsFolder

#Declaration of script variables
    $Client = "Client Name"
    $Server = (Get-CimInstance -ClassName Win32_ComputerSystem).Name
    $Date = Get-Date
    $LogPath = "C:\Logs\StateServer.log"

# Define the email address to send notifications to
    $to = "YourEmailAdress"
    $to2 = "OtherEmailAdress"
	
If ($Option -eq "Reboot")
	{
#Send the notification
    Write-Output "$($Date) Send alert email to $($to) and $($to2) : The server $Server has rebooted." | Tee-Object -FilePath $LogPath -Append
	Send-MailMessage -To $($to;$to2) -From "SenderEmailAdress" -SmtpServer SmtpAdress -Subject "$Client - $Server - Server Reboot" -Body "The server $Server has rebooted."
	}

If  ($Option -eq "Shutdown")
	{
#Send the notification
    Write-Output "$($Date) Send alert email to $($to) and $($to2) : The server $Server has been shutdown." | Tee-Object -FilePath $LogPath -Append
	Send-MailMessage -To $($to;$to2) -From "SenderEmailAdress" -SmtpServer SmtpAdress -Subject "$Client - $Server - Server Shutdown" -Body "The server $Server has been shutdown."
	}
