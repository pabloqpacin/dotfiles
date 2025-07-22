
function 001 {
    Get-ADUser -Filter "Name -notlike 'k*'" -SearchBase "CN=Users,DC=asix,DC=local" | foreach-object {
        get-aduser -identity $_ -properties * | bat -l ps1
    }
}


function 002 {
    Get-ADGroup -Filter "Name -like 'Adm*'" | foreach-object {
        Get-ADGroupMember -Identity $_
    }
}

function 003 {
    # $DC = (Get-ADDomain).DistinguishedName
    # Get-ADOrganizationalUnit -Filter * -SearchBase "OU=Domain Controllers,$DC" -Properties *
    # # Get-ADOrganizationalUnit -Filter * -SearchBase "OU=Domain Controllers,DC=asix,DC=local" -Properties *
    Get-ADOrganizationalUnit -Filter * -SearchBase "OU=Domain Controllers,$((Get-ADDomain).DistinguishedName)" -Properties *
    Get-ADDomainController -Discover
}
