<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.157
	 Created on:   	2/8/2019 12:12 PM
	 Created by:   	CERBDM
	 Organization: 	
	 Filename:     	VE_XD7StoreFrontRoamingGateway.psm1
	-------------------------------------------------------------------------
	 Module Name: VE_XD7StoreFrontRoamingGateway
	===========================================================================
#>



Import-LocalizedData -BindingVariable localizedData -FileName VE_XD7StoreFrontRoamingGateway.Resources.psd1;

function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[parameter(Mandatory = $true)]
		[ValidateSet("UsedForHDXOnly","Domain","RSA","DomainAndRSA","SMS","GatewayKnows","SmartCard","None")]
		[System.String]
		$LogonType,

		[System.String]
		$SmartCardFallbackLogonType,

		[System.String]
		$Version,

		[parameter(Mandatory = $true)]
		[System.String]
		$GatewayUrl,

		[System.String]
		$CallbackUrl,

		[System.Boolean]
		$SessionReliability,

		[System.Boolean]
		$RequestTicketTwoSTAs,

		[System.String]
		$SubnetIPAddress,

		[System.String]
		$SecureTicketAuthorityUrls,

		[System.Boolean]
		$StasUseLoadBalancing,

		[System.String]
		$StasBypassDuration,

		[System.String]
		$GslbUrl,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

		Import-module Citrix.StoreFront -ErrorAction Stop;

		try {
			$Gateway = Get-STFRoamingGateway
			If ($Gateway) {
				#Convert Arrays to Strings
				$strSTAUrl = ($Gateway.SecureTicketAuthorityUrls) -join (",")
			}
		}
		catch { }

		$returnValue = @{
			Name = [System.String]$Gateway.Name
			LogonType = [System.String]$Gateway.Logon
			SmartCardFallbackLogonType = [System.String]$Gateway.SmartCardFallback
			Version = [System.String]$Gateway.Version
			GatewayUrl = [System.String]$Gateway.Location
			CallbackUrl = [System.String]$Gateway.CallbackUrl
			SessionReliability = [System.Boolean]$Gateway.SessionReliability
			RequestTicketTwoSTAs = [System.Boolean]$Gateway.RequestTicketTwoStas
			SubnetIPAddress = [System.String]$Gateway.IpAddress
			SecureTicketAuthorityUrls = [System.String]$strSTAUrl
			StasUseLoadBalancing = [System.Boolean]$Gateway.StasUseLoadBalancing
			StasBypassDuration = [System.String]$Gateway.StasBypassDuration
			GslbUrl = [System.String]$Gateway.GslbLocation
		}

	$returnValue
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[parameter(Mandatory = $true)]
		[ValidateSet("UsedForHDXOnly","Domain","RSA","DomainAndRSA","SMS","GatewayKnows","SmartCard","None")]
		[System.String]
		$LogonType,

		[System.String]
		$SmartCardFallbackLogonType,

		[System.String]
		$Version,

		[parameter(Mandatory = $true)]
		[System.String]
		$GatewayUrl,

		[System.String]
		$CallbackUrl,

		[System.Boolean]
		$SessionReliability,

		[System.Boolean]
		$RequestTicketTwoSTAs,

		[System.String]
		$SubnetIPAddress,

		[System.String]
		$SecureTicketAuthorityUrls,

		[System.Boolean]
		$StasUseLoadBalancing,

		[System.String]
		$StasBypassDuration,

		[System.String]
		$GslbUrl,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
)

		Import-module Citrix.StoreFront -ErrorAction Stop;
		$Gateway = Get-STFRoamingGateway

		If ($Ensure -eq "Present") {
			#Region Create Params hashtable
			$AllParams = @{}
			$ChangedParams = @{
				Name = $Name
				LogonType = $LogonType
				GatewayUrl = $GatewayUrl
			}
			$targetResource = Get-TargetResource @PSBoundParameters;
			foreach ($property in $PSBoundParameters.Keys) {
				if ($targetResource.ContainsKey($property)) {
					if (!($AllParams.ContainsKey($property))) {
						$AllParams.Add($property,$PSBoundParameters[$property])
					}
					$expected = $PSBoundParameters[$property];
					$actual = $targetResource[$property];
					if ($PSBoundParameters[$property] -is [System.String[]]) {
						if (Compare-Object -ReferenceObject $expected -DifferenceObject $actual) {
							if (!($ChangedParams.ContainsKey($property))) {
								Write-Verbose "Adding $property to ChangedParams"
								$ChangedParams.Add($property,$PSBoundParameters[$property])
							}
						}
					}
					elseif ($expected -ne $actual) {
						if (!($ChangedParams.ContainsKey($property))) {
							Write-Verbose "Adding $property to ChangedParams"
							$ChangedParams.Add($property,$PSBoundParameters[$property])
						}
					}
				}
			}
			#endregion

			If ($Gateway) {
				#Set changed parameters
				$ChangedParams | Export-Clixml c:\Temp\ChangedParams.xml
				Write-Verbose "Calling Set-STFRoamingGateway"
				Set-STFRoamingGateway @ChangedParams -confirm:$false
			}
			Else {
				#Create gateway
				$AllParams | Export-Clixml c:\Temp\AllParams.xml
				Write-Verbose "Calling Add-STFRoamingGateway"
				Add-STFRoamingGateway @AllParams -confirm:$false
			}

		}
		Else {
			#Uninstall
			$Gateway | Remove-STFRoamingGateway -confirm:$false
		}


	#Include this line if the resource requires a system reboot.
	#$global:DSCMachineStatus = 1


}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[parameter(Mandatory = $true)]
		[ValidateSet("UsedForHDXOnly","Domain","RSA","DomainAndRSA","SMS","GatewayKnows","SmartCard","None")]
		[System.String]
		$LogonType,

		[System.String]
		$SmartCardFallbackLogonType,

		[System.String]
		$Version,

		[parameter(Mandatory = $true)]
		[System.String]
		$GatewayUrl,

		[System.String]
		$CallbackUrl,

		[System.Boolean]
		$SessionReliability,

		[System.Boolean]
		$RequestTicketTwoSTAs,

		[System.String]
		$SubnetIPAddress,

		[System.String]
		$SecureTicketAuthorityUrls,

		[System.Boolean]
		$StasUseLoadBalancing,

		[System.String]
		$StasBypassDuration,

		[System.String]
		$GslbUrl,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

		$targetResource = Get-TargetResource @PSBoundParameters;
		If ($Ensure -eq 'Present') {
			$inCompliance = $true;
			foreach ($property in $PSBoundParameters.Keys) {
				if ($targetResource.ContainsKey($property)) {
					$expected = $PSBoundParameters[$property];
					$actual = $targetResource[$property];
					if ($PSBoundParameters[$property] -is [System.String[]]) {
						if (Compare-Object -ReferenceObject $expected -DifferenceObject $actual) {
							Write-Verbose ($localizedData.ResourcePropertyMismatch -f $property, ($expected -join ','), ($actual -join ','));
							$inCompliance = $false;
						}
					}
					elseif ($expected -ne $actual) {
						Write-Verbose ($localizedData.ResourcePropertyMismatch -f $property, $expected, $actual);
						$inCompliance = $false;
					}
				}
			}
		}
		Else {
			If ($targetResource.Name -eq $Name) {
				$inCompliance = $false
			}
			Else {
				$inCompliance = $true
			}
		}

		if ($inCompliance) {
			Write-Verbose ($localizedData.ResourceInDesiredState -f $DeliveryGroup);
		}
		else {
			Write-Verbose ($localizedData.ResourceNotInDesiredState -f $DeliveryGroup);
		}

		return $inCompliance;
}


Export-ModuleMember -Function *-TargetResource

