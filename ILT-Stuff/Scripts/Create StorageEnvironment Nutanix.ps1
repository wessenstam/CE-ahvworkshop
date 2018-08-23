# *********************************************************************************
# Script for creating the NPP NTNX environment for CE workshop
# Parameters for the scripts to run:
# Nutanix Cmdlets
# ----------------------------------------------------------------------------------
# Versioning
# v0.1 - Willem Essenstam - 19-04-2016
# *********************************************************************************

#
# Load the Nutanix modules
Add-PsSnapin NutanixCmdletsPSSnapin

# Set parameters
$NTNXCluster="192.168.2.210"
$NTNXUser="admin"
$NTNXPassword="admin"
$NTNXStoragePoolName="SP1"

# Connect to NutanixCluster 
Connect-NTNXCluster -Server $NTNXCluster -UserName $NTNXUser -Password $NTNXPassword -AcceptInvalidSSLCerts:$true

# Check if there is a Storagepool; if not, create one for all disks in the cluster
# Get the storagepool of the cluster
$NTNXStoragePool=Get-NTNXStoragePool
if (!$NTNXStoragePool){
# No storagepool detected;
# get all disks and put them in an array which we need later
    $array =@()    (get-NTNXdisk) |% {        $hardware = $_        write-host "Adding disk "$hardware.id" to the array"        $array += $hardware.id    }

# Create the storagepool from all disks using the array we've created earlier
    write-host "Creating the StoragePool"$NTNXStoragePoolName
    New-NTNXStoragePool -Name $NTNXStoragePoolName -Disks $array


}else{
    write-host "Storagepool found with name"$NTNXStoragePool.Name
}

# Check for a container named CE-vm's; if not than create it
# Check for CE container
$NTNXContainer=get-ntnxcontainer
$NTNXCntr=$null
$NTNXCntrFound=0
foreach ($NTNXCntr in $NTNXContainer.name){
    write-host $NTNXCntr
    if ($NTNXCntr -eq "CE"){
        write-host "Found Container CE; using container"$NTNXCntr
        $NTNXCntrFound=1
    }
}
if ($NTNXCntrFound -eq 0){
    write-host "Container CE not found. Creating container CE"
    New-NTNXContainer -Name CE -StoragePoolId $NTNXStoragePool.id -FingerPrintOnWrite:on
    write-host "Adding container CE to ESXi hosts"    add-NTNXnfsDatastore -containerName CE
}

# Disconnect from NutanixCluster
Disconnect-NTNXCluster *