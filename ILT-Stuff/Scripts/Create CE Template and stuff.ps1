# Script for automating the CE installation process in the NPP sessions# Step 1: create a container called CE-CNTR for the CE versions# Step 2: Have the OVA uploaded# Step 3: Create template from the uploaded OVA# Step 4: Clone the template x amount of times; depending on the amount of attendees# ----------------------------------------------------------------------------------# Script versioning:# v0.1 - Willem Essenstam - 19-04-2016# ----------------------------------------------------------------------------------# Parameters for the scripts to run:# VMWare PowerCLI 6.3# Nutanix PowerShell Cmdlets 4.6# ----------------------------------------------------------------------------------#

# **********************************************************************************# * Nutanix stuff to be done (Step 1)                                              *# **********************************************************************************
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
    $array =@()    (get-NTNXdisk) |% {        $hardware = $_        write-host "Adding disk "$hardware.id" to the array"        $array += $hardware.id    }

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
# Mounting the newly created CE-vms container to the ESXi servers    write-host "Adding container CE-vms to ESXi hosts"    add-NTNXnfsDatastore -containerName CE-vms
}

# Disconnect from NutanixCluster
Disconnect-NTNXCluster *
write-host "Disconnecting from Cluster"$NTNXCluster#> End DEBUG!!
# *********************************************************************************# * VMware stuff to be done (Step 2 till 41,b,c,d)                                       *# *********************************************************************************

write-host "Starting the VMware part of the deployment"

# Load the VMware PowerCLI modulesAdd-PSSnapin VMware.VimAutomation.Core
# Setting the parameters needed$array=$null$vCenter="192.168.3.10"$ESXi1="192.168.3.30"$ESXi2="192.168.3.31"$ESXi3="192.168.3.32"#$ESXi4="192.168.3.33"$ESXUser="root"$ESXPassword="nutanix/4u"$VCUser="administrator@vsphere.local"$VCPassword="Nutanix/4u"$AmountClones="10"$OVASource="E:\Nutanix Stuff\CE version\cetempl46.ova"$VMDatastore="CE-vms"
# Connect to the Virtualisation server using parameterswrite-host "Connecting to vCenter Server"#connect-viserver -server $ESXiServer -user $ESXUser -password $ESXPasswordconnect-viserver -server $vCenter -user $VCUser -password $VCPassword
# Step 2 Import the ova file
write-host "Importing ova template of the CE vm"import-vapp -Source $OVASource -VMHost $ESXi1  -Datastore $VMDatastore -DiskStorageFormat "Thin" -Confirm:$false# Step 3 convert uploaded ova into templateWrite-host "Converting uploaded VM into Template"set-vm -ToTemplate -VM cetempl46 -confirm:$false# Step 4a; deploy vm's from the created templatewrite-host "Deploying"$AmountClones" clones from the created template"# Create helper array$array = @()for ($i=1; $i -le $AmountClones; $i++){    $array += ,@($i)}# Step 4b; start cloning the ce machinesforeach ($i in $array){    New-vm -vmhost $ESXi1 -Name ce$i -Template cetempl46 -Datastore CE-vms -DiskStorageFormat Thin -RunAsync}
# Sleep 1 minute to give the system time to ready the cloning.
write-host "Sleep 30 seconds to give the system time to get all clones ready"
Start-Sleep -Seconds 30

# Step 4c; powering the clones on
write-host "Powering on the Clones"
foreach ($i in 1,2,3){    Start-vm -vm ce$i -RunAsync -Confirm:$false}

# Step 4d; allowing promicious mode on the vswitch0 on all hosts
write-host "Setting the vSwitch0 switches to Promicious mode enabled"
Get-VirtualSwitch -Name "vSwitch0" | Get-SecurityPolicy | Set-SecurityPolicy -AllowPromiscuous $True

# Disconnecting alldisconnect-viserver * -Force -Confirm:$false