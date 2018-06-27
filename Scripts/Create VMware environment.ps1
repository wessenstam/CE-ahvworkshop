# *********************************************************************************
# Script for adding ESXi servers to vCenter server
# Parameters for the scripts to run:
# VMWare PowerCLI 6.3
# ----------------------------------------------------------------------------------
# Versioning
# v0.1 - Willem Essenstam - 19-04-2016
# *********************************************************************************

#
# Load the VMware PowerCLI modules
Add-PSSnapin VMware.VimAutomation.Core

# Setting the parameters needed
$vCenter="10.64.40.2"
$ESXi1="10.64.40.51"
$ESXi2="10.64.40.52"
$ESXi3="10.64.40.53"
$ESXi4="10.64.40.54"
$ESXIHosts=$ESXi1,$ESXi2,$ESXi3,$ESXi4
$ESXUser="root"
$ESXPassword="nutanix/4u"
$VCUser="administrator@vsphere.local"
$VCPassword="Nutanix/4u"

# Connecting to the vCenter server
connect-viserver -server $vCenter -User $VCUser -Password $VCPassword

# Create the datacenter
New-Datacenter -Location Datacenters -Name DEMO -Confirm:$false


# Create the Cluster
New-Cluster -Location Demo -Name NPP -HAEnabled -DrsEnabled -DrsAutomationLevel FullyAutomated

# Add the ESXi hosts to the cluster
foreach ($VMHost in $ESXIHosts){
    Add-VMHost -Name $VMHost -Location NPP -User $ESXUser -Password $ESXPassword -Force -RunAsync
    }
# Remove the ESXi hosts to the cluster
#foreach ($VMHost in $ESXIHosts){
#    Remove-VMHost $VMHost -Confirm:$false 
#    }


# Disconnecting the vCenter
Disconnect-viserver -server $vCenter -Force -Confirm:$false