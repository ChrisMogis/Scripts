$reminderdays="14" # Remind before days.
$priorityreminder="3" # set Days before you want to message with High Importance.
$outfile="c:\scripts\temp" # Output path to whom email was sent and days to expire.
$from="ohached@advenis.com" #Enter email senders email.
$smtp="adv220sep02.advenis.com" # set your Smtp server.

If ( ! (Get-module ActiveDirectory )) {
  Import-Module ActiveDirectory
  Cls
  }
$AllUsers=get-aduser -filter {(Enabled -eq $true) -and (PasswordNeverExpires -eq $false)} -properties Name, PasswordNeverExpires, PasswordExpired, PasswordLastSet, EmailAddress | where { $_.passwordexpired -eq $false }

foreach ($User in $AllUsers)
{
 $Name = $user.name
 $Email = $User.emailaddress
 $PasswdSetDate = $user.passwordlastset
 $DefaultMaxPasswdAge=(Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge
# Check for Fine Grained Password  
    $PasswordPol = (Get-AduserResultantPasswordPolicy $user)  
    if (($PasswordPol) -ne $null) 
    { 
     $passwordage = $PasswordPol.maxpasswordage
    }
    else{
    $passwordage=$DefaultMaxPasswdAge
    }
    
  $ExpireDate = $PasswdSetDate + $passwordage
  $Today = (get-date)
  $DaysToExpire = (New-TimeSpan -Start $Today -End $ExpireDate).Days
  ## you can Modify Email subject here
  $EmailSubject="Password Expiry Notice - your password expires in $DaystoExpire days"
  
  
  
  
  ## Modify the message user user going to Receive.
  $DefaultMessage="
  Bonjour $Name,

Votre mot de passe expirera dans (Get-Date).AddDays($DaysToExpire).ToString('dd-MMM-yyyy hh:mm tt') jours. Pour le changer, il suffira d'effectuer la combinaison de touches suivante: CTRL+ALT+SUPPR et choisir: Modifier un mot de passe.
  
  Le mot de passe doit contenir au minimum:
  
    - Une minuscule [a-z]
    - Une majuscule [A-Z]
    - Un chiffre [0-9]

  Le mot de passe ne doit pas contenir:

    - Votre Nom ou Prénom
    - L'un des 8 derniers mots de passe déjà utilisés
    - L'un des caractères spéciaux suivants ~!@#$%^&*()_+={}[]|\;:<>/?

La procédure de changement de mot de passe est également accessible via ce lien:
    
    - $pnormal (changement via windows)
    - $pintune (changement via Intune)

Si le mot de passe n'est pas changé dans le délai indiqué, il ne sera plus possible de se connecter à certains services. 

Merci de votre compréhension. 

Nous restons disponible via le portail du support ($support) en cas de besoin.

L'équipe informatique
"

 ## Modify the message user user going to Receive.
$UrgentMessage="
Bonjour $Name,

Votre mot de passe expirera dans (Get-Date).AddDays($DaysToExpire).ToString('dd-MMM-yyyy hh:mm tt') jours. Pour le changer, il suffira d'effectuer la combinaison de touches suivante: CTRL+ALT+SUPPR et choisir: Modifier un mot de passe.
  
  Le mot de passe doit contenir au minimum:
  
    - Une minuscule [a-z]
    - Une majuscule [A-Z]
    - Un chiffre [0-9]

  Le mot de passe ne doit pas contenir:

    - Votre Nom ou Prénom
    - L'un des 8 derniers mots de passe déjà utilisés
    - L'un des caractères spéciaux suivants ~!@#$%^&*()_+={}[]|\;:<>/?

La procédure de changement de mot de passe est également accessible via ce lien:
    
    - $pnormal (changement via windows)
    - $pintune (changement via Intune)

Si le mot de passe n'est pas changé dans le délai indiqué, il ne sera plus possible de se connecter à certains services. 

Merci de votre compréhension. 

Nous restons disponible via le portail du support ($support) en cas de besoin.

L'équipe informatique
"

## Modify the message user going to Receive.

IF($DaysToExpire -le $priorityreminder)
{
$MailMessage = @{ 
    To = $Email
    From = $from
    Subject = $EmailSubject
    Body = $UrgentMessage
    priority="high"
    Smtpserver = $smtp
    ErrorAction = "SilentlyContinue" 
}
Send-MailMessage @MailMessage -bodyashtml
}

ElseIf($DaysToExpire -eq $reminderdays)
{
$MailMessage = @{ 
    To = $Email
    From = $from
    Subject = $EmailSubject
    Body = $DefaultMessage
    Smtpserver = $smtp
    ErrorAction = "SilentlyContinue" 
}
Send-MailMessage @MailMessage -bodyashtml
}

}

if ( !(test-path $outfile)) {
    new-item $outfile -type directory -Force 
}
$date=[datetime]::Today.ToString('dd-MM-yyyy')
$name + ',' + $reminderdays + ',' +$priorityreminder|
Out-File $outfile\sentTo' '$($date).txt -Append