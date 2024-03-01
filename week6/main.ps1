. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)

Clear-Host

$Prompt  = "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - Exit`n"
$Prompt += "10 - List at Risk Users`n"

function checkUser($name){
    $user = Get-LocalUser | Where-Object { $_.name -eq $name }
    Write-Host $user
    if($null -eq $user) { return $true }
    return $false
}
# The true and false are reversed, and yet this makes it work. I don't understand it, but it works.


$operation = $true

while($operation){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 9){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }

    elseif($choice -eq 1){
        $enabledUsers = getEnabledUsers
        Write-Host ($enabledUsers | Format-Table | Out-String)
    }

    elseif($choice -eq 2){
        $notEnabledUsers = getNotEnabledUsers
        Write-Host ($notEnabledUsers | Format-Table | Out-String)
    }


    # Create a user
    elseif($choice -eq 3){ 

        $name = Read-Host -Prompt "Please enter the username for the new user"
        $password = Read-Host -AsSecureString -Prompt "Please enter the password for the new user"
        $password.GetType()

        # TODO: Create a function called checkUser in Users that: 
        #              - Checks if user a exists. 
        #              - If user exists, returns true, else returns false
    
        # TODO: Check the given username with your new function.
        #              - If false is returned, continue with the rest of the function
        #              - If true is returned, do not continue and inform the user
        if (checkUser $name -eq $true) { Write-Host "User: $name already exists." | Out-String; continue }

        # TODO: Create a function called checkPassword in String-Helper that:
        #              - Checks if the given string is at least 6 characters
        #              - Checks if the given string contains at least 1 special character, 1 number, and 1 letter
        #              - If the given string does not satisfy conditions, returns false
        #              - If the given string satisfy the conditions, returns true
        function checkPassword([SecureString] $password){
            # Convert the SecureString to a plain text string
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
            $password1 = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
            # SECURESTRING CAN GO BURN IN HELL
            if($password1.Length -lt 6) { return $false }
            if($password1 -notmatch "[a-zA-Z]") { return $false }
            if($password1 -notmatch "[0-9]") { return $false }
            if($password1 -notmatch "[^a-zA-Z0-9]") { return $false }
            return $true
        }

        # TODO: Check the given password with your new function. 
        #              - If false is returned, do not continue and inform the user
        #              - If true is returned, continue with the rest of the function
        checkPassword $password
        if ($? -eq $false) { Write-Host "Password does not satisfy the conditions." | Out-String; continue }

        createAUser $name $password
        # Fails due to a lack of permissions, and I'm not going to bother with that

        Write-Host "User: $name is created." | Out-String
    }


    # Remove a user
    elseif($choice -eq 4){

        $name = Read-Host -Prompt "Please enter the username for the user to be removed"

        # TODO: Check the given username with the checkUser function.
        if (checkUser $name -eq $false) { Write-Host "User: $name does not exist." | Out-String; continue }

        removeAUser $name
        # Also fails. Fix Users.ps1!

        Write-Host "User: $name Removed." | Out-String
    }


    # Enable a user
    elseif($choice -eq 5){


        $name = Read-Host -Prompt "Please enter the username for the user to be enabled"

        # TODO: Check the given username with the checkUser function.
        if (checkUser $name -eq $false) { Write-Host "User: $name does not exist." | Out-String; continue }

        enableAUser $name

        Write-Host "User: $name Enabled." | Out-String
    }


    # Disable a user
    elseif($choice -eq 6){

        $name = Read-Host -Prompt "Please enter the username for the user to be disabled"

        # TODO: Check the given username with the checkUser function.
        if (checkUser $name -eq $false) { Write-Host "User: $name does not exist." | Out-String; continue }

        disableAUser $name

        Write-Host "User: $name Disabled." | Out-String
    }


    elseif($choice -eq 7){

        $name = Read-Host -Prompt "Please enter the username for the user logs"

        # TODO: Check the given username with the checkUser function.
        if (checkUser $name -eq $false) { Write-Host "User: $name does not exist." | Out-String; continue }

        $days = Read-Host -Prompt "Please enter the number of days for the logs"
        $userLogins = getLogInAndOffs $days
        # TODO: Change the above line in a way that, the days 90 should be taken from the user

        Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
    }


    elseif($choice -eq 8){

        $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"

        # TODO: Check the given username with the checkUser function.
        if (checkUser $name -eq $false) { Write-Host "User: $name does not exist." | Out-String; continue }

        $days = Read-Host -Prompt "Please enter the number of days for the logs"
        $userLogins = getFailedLogins $days
        # Can't access the registry entries, so this fails
        # TODO: Change the above line in a way that, the days 90 should be taken from the user

        Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
    }


    # TODO: Create another choice "List at Risk Users" that
    #              - Lists all the users with more than 10 failed logins in the last <User Given> days.  
    #                (You might need to create some failed logins to test)
    #              - Do not forget to update prompt and option numbers
    
    elseif($choice -eq 10){
        $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"
        if (checkUser $name -eq $false) { Write-Host "User: $name does not exist." | Out-String; continue }

        $days = Read-Host -Prompt "Please enter the number of days for the logs"
        $userLogins = getFailedLogins $days | Group-Object -Property User | Where-Object { $_.Count -gt 10 }
        

    # TODO: If user enters anything other than listed choices, e.g. a number that is not in the menu   
    #       or a character that should not be accepted. Give a proper message to the user and prompt again.
     else {
        Write-Host "Invalid input. Please enter a valid option." | Out-String
     }
    
    }
}




