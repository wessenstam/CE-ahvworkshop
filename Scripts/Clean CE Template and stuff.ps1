# Script for automating the CE installation process in the NPP sessions# Step 1: create a container called CE-CNTR for the CE versions# Step 2: Have the OVA uploaded# Step 3: Create template from the uploaded OVA# Step 4: Clone the template x amount of times; depending on the amount of attendees# ----------------------------------------------------------------------------------# Script versioning:# v0.1 - Willem Essenstam - 19-04-2016# v0.2 - Willem Essenstam - 12-12-2016; added a foreach loop for setting promisicous#                                       mode on the vSwitch0 of all esxi nodes# ----------------------------------------------------------------------------------# Parameters for the scripts to run:# VMWare PowerCLI 6.3# Nutanix PowerShell Cmdlets 4.6# ----------------------------------------------------------------------------------#


# *********************************************************************************# * VMware stuff to be done (Step 2 till 41,b,c,d)                                *# *********************************************************************************#<#
# Load the VMware PowerCLI modulesAdd-PSSnapin VMware.VimAutomation.Core
# Setting the parameters needed# VMware Parameters$array=$null$vCenter="10.64.40.2"$ESXi1="10.64.40.51"$ESXi2="10.64.40.52"$ESXi3="10.64.40.53"$ESXi4="10.64.40.54"$ESXiServers=@($ESXi1,$ESXi2,$ESXi3,$ESXi4)$ESXUser="root"$ESXPassword="nutanix/4u"$VCUser="administrator@vsphere.local"$VCPassword="Nutanix/4u"#$AmountClones="6"$VMDatastore="CE-vms"#>



# Connect to each ESXi server in the array ESXiServers and set the promisicous mode to enable
foreach ($i in $ESXiServers){ 
# Connect to the Virtualisation server using parameters    write-host "Connecting to vCenter Server"    connect-viserver -server $i -user $ESXUser -password $ESXPassword

    # Step 1; allowing promicious mode on the vswitch0 on all hosts
    write-host "Setting the vSwitch0 switches to Promicious mode enabled"
    Get-VirtualSwitch -Name "vSwitch0" | Get-SecurityPolicy | Set-SecurityPolicy -AllowPromiscuous $True

    # Disconnecting all    disconnect-viserver * -Force -Confirm:$false
    }
# Create helper array$array = @()for ($i=1; $i -le $AmountClones; $i++){    $array += ,@($i)}

# Step 2; powering off the clones on
write-host "Powering off the Clones"
foreach ($i in $array){    Stop-vm -vm ce$i -Confirm:$false -RunAsync}

# Sleep 1 minute to give the system time to stop all VM's.
write-host "Sleep 30 seconds to give the system time to stop all VM's"
Start-Sleep -Seconds 30

# Step 3: remove the vm'swrite-host "Deleting"$AmountClones" clones."foreach ($i in $array){    remove-vm -vm ce$i -DeletePermanently -RunAsync -Confirm:$False}

# Step 4 delete templateWrite-host "Deleting the Template"remove-template -Template cetempl46 -DeletePermanently -confirm:$false
#>

#<#
# **********************************************************************************# * Nutanix stuff to be done (Step 1)                                              *# **********************************************************************************
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
write-host "Disconnecting from Cluster"$NTNXClusterDisconnect-NTNXCluster *#>