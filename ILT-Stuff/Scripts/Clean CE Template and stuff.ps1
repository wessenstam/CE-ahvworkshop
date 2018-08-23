﻿# Script for automating the CE installation process in the NPP sessions


# *********************************************************************************
# Load the VMware PowerCLI modules
# Setting the parameters needed



# Connect to each ESXi server in the array ESXiServers and set the promisicous mode to enable
foreach ($i in $ESXiServers){ 
# Connect to the Virtualisation server using parameters

    # Step 1; allowing promicious mode on the vswitch0 on all hosts
    write-host "Setting the vSwitch0 switches to Promicious mode enabled"
    Get-VirtualSwitch -Name "vSwitch0" | Get-SecurityPolicy | Set-SecurityPolicy -AllowPromiscuous $True

    # Disconnecting all
    }


# Step 2; powering off the clones on
write-host "Powering off the Clones"
foreach ($i in $array){

# Sleep 1 minute to give the system time to stop all VM's.
write-host "Sleep 30 seconds to give the system time to stop all VM's"
Start-Sleep -Seconds 30

# Step 3: remove the vm's

# Step 4 delete template
#>


# **********************************************************************************
# This part of the script must check if there is a StoragePool; if not create one called SP1
# Then check if there is a CE-vms container in the Cluster available; if not create one

# Load the Nutanix modules
Add-PsSnapin NutanixCmdletsPSSnapin

# Nutanix Parameters
$NTNXCluster="192.168.3.50"
$NTNXUser="admin"
$NTNXPassword="nutanix/4u"
$NTNXStoragePoolName="SP1"

# Connect to NutanixCluster 
write-host "Connecting to cluster"$NTNXCluster
Connect-NTNXCluster -Server $NTNXCluster -UserName $NTNXUser -Password $NTNXPassword -AcceptInvalidSSLCerts:$true -ForcedConnection

# Step 4a; Unmount the CE-vms Datastore from the ESXi servers
write-host "Unmounting the datastore from the ESXi servers"
Remove-NTNXNfsDatastore -DatastoreName CE-vms

# Step 4b; Delete the CE-vms container
write-host "Deleting the CE-vms container"
$NTNXCntrId=Get-NTNXContainer
$NTNXCntrIDNR=$NTNXCntrId | where {$_.Name -eq "CE-vms"} | select id
Remove-NTNXContainer -Id $NTNXCntrIDNR

# Step 4c; Delete the Storagepool
# Get the storagepool of the cluster
Write-host "Deleting the storagepool"
$NTNXStoragePool=Get-NTNXStoragePool
$NTNXStoragePoolID=$NTNXStoragePool|where {$_.name -eq "SP1"} | select id
Remove-NTNXStoragePool -id $NTNXStoragePoolID

# Disconnect from NutanixCluster
write-host "Disconnecting from Cluster"$NTNXCluster