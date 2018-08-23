﻿# Script for automating the CE installation process in the NPP sessions

# **********************************************************************************
# This part of the script must check if there is a StoragePool; if not create one called SP1
# Then check if there is a CE-vms container in the Cluster available; if not create one

#<# Begin Debug!!
# Load the Nutanix modules
Add-PsSnapin NutanixCmdletsPSSnapin

# Set parameters
$NTNXCluster="192.168.3.45"
$NTNXUser="admin"
$NTNXPassword="nutanix/4u"
$NTNXStoragePoolName="SP1"

# Use the below parameter on Commandlets version 4.6 and higher..
$NTNXPwdSec=ConvertTo-SecureString -String $NTNXPassword -AsPlainText -Force

# Connect to NutanixCluster 
write-host "Connecting to cluster"$NTNXCluster
Connect-NTNXCluster -Server $NTNXCluster -UserName $NTNXUser -Password $NTNXPassword -AcceptInvalidSSLCerts:$true -ForcedConnection

# Check if there is a Storagepool; if not, create one for all disks in the cluster
# Get the storagepool of the cluster
$NTNXStoragePool=Get-NTNXStoragePool
if (!$NTNXStoragePool){
# No storagepool detected;
# get all disks and put them in an array which we need later
    $array =@()

# Create the storagepool from all disks using the array we've created earlier
    write-host "Creating the StoragePool"$NTNXStoragePoolName
    New-NTNXStoragePool -Name $NTNXStoragePoolName -Disks $array


}else{
    write-host "Storagepool found with name"$NTNXStoragePool.Name
}

# Check for a container named CE-vms; if not than create it
# Check for CE-vms container
write-host "Checking for CE-vms container"
$NTNXContainer=get-ntnxcontainer
$NTNXCntr=$null
$NTNXCntrFound=0
foreach ($NTNXCntr in $NTNXContainer.name){
    if ($NTNXCntr -eq "CE-vms"){
        write-host "Found Container CE-vms; using container"$NTNXCntr
        $NTNXCntrFound=1
    }
}
if ($NTNXCntrFound -eq 0){
# Creating CE-vms container
    write-host "Container CE-vms not found. Creating container CE-vms"
    New-NTNXContainer -Name CE-vms -StoragePoolId $NTNXStoragePool.id -FingerPrintOnWrite:on
# Mounting the newly created CE-vms container to the ESXi servers
}

# Disconnect from NutanixCluster
Disconnect-NTNXCluster *
write-host "Disconnecting from Cluster"$NTNXCluster
# *********************************************************************************

write-host "Starting the VMware part of the deployment"

# Load the VMware PowerCLI modules
# Setting the parameters needed
# Connect to the Virtualisation server using parameters
# Step 2 Import the ova file
write-host "Importing ova template of the CE vm"
# Sleep 1 minute to give the system time to ready the cloning.
write-host "Sleep 30 seconds to give the system time to get all clones ready"
Start-Sleep -Seconds 30

# Step 4c; powering the clones on
write-host "Powering on the Clones"
foreach ($i in 1,2,3){

# Step 4d; allowing promicious mode on the vswitch0 on all hosts
write-host "Setting the vSwitch0 switches to Promicious mode enabled"
Get-VirtualSwitch -Name "vSwitch0" | Get-SecurityPolicy | Set-SecurityPolicy -AllowPromiscuous $True

# Disconnecting all