# ************************************************************
# Create a TEST Vm and it's network for scripting purposes
# ************************************************************
# 27-05-2017 - WE - Initial setup against ESXi 6.0
# 04-08-2017 - WE - Edited for the Frankfurt DSC
# ************************************************************

# Load the VMware PowerCLI modules
Add-PSSnapin VMware.VimAutomation.Core

# Set Variables:
# This version just has all the variables at the top.
# These variables are HOST specific...
$vCenter = "172.18.78.60"
$VCUser = "administrator@vsphere.local"
$VCPassword ="Nutanix/4u"

#$VCUser = "dscfra\shoffmann"
#$VCPassword ="Noah2407!"


$ESXi1="172.18.78.20"
$ESXi2="172.18.78.21" # Not used for the NPP yet
$ESXi3="172.18.78.22"
$ESXi4="172.18.78.23"
$ESXi5="172.18.78.24"
$ESXi6="172.18.78.25"

$ESXiServers=@($ESXi1,$ESXi2,$ESXi3,$ESXi4,$ESXi5,$ESXi6)

$vmHostUser="root"
$vmHostPassword="nutanix/4u"
$StudentsNr=7 # 8 People will be working on this
$VMNumber=6 # VyOS, Windows AD, CE1..4

# NUtanix Cluster parameter
$DataStore = "Tranining"

<#
    
foreach($vmhost in $ESXiServers){

    # Connect to the vCenter server for the Templates etc
    #connect-viserver -server $vCenter -User $VCUser -Password $VCPassword
        
    # Connect to the ESXi Server
    connect-viserver -server $vmhost -User $vmHostUser -Password $vmHostPassword


    # Create TestNetwork also needed for the Templates which should be part of this network
    New-VirtualPortGroup -Name TempNetwork -VirtualSwitch vSwitch0 -VLanId 4000
        # Create the extra VirtualPortGroups one per student session on vSwitch0 as DRS may move machines. Have each student VM to VLAN 3000+Student number(1-x)     # Change the network adapters on the VMs to correspond to the right VLAN/Network Names    # Only the Vyos "External" network has to stay connected to the External VM Network so it can route info    # Change the name of the VMs corresponding to the student's ID    for ($i=1; $i -le $StudentsNr; $i++){
 
        # Create virtualportgroups with VLANs in the 3000+ range name Student-x
        New-VirtualPortGroup -Name Student-$i -VirtualSwitch vSwitch0 -VLanId 300$i

    }
    disconnect-VIServer -force:$true -Confirm:$false -server *
}
#>


connect-viserver -server $vCenter -user $VCUser -password $VCPassword

    # Set the Promicious mode to true on vSwitch0 on all ESXi servers in the cluster
    # Get-VirtualSwitch -Name "vSwitch0" | Get-SecurityPolicy | Set-SecurityPolicy -AllowPromiscuous $True
    For ($i=1; $i -le $StudentsNr; $i++){
        # Create a new ResourcePool named after the student number
        $clusterRootRP = Get-ResourcePool -Location ( Get-Cluster DEMO )-Name Resources    
        New-ResourcePool -Name Student-$i -Location $clusterRootRP -Confirm:$false            
        $ESXiServer="172.18.78.23"

        # Clone the Machines from the templates
        # The CEs
        New-VM -Name CE1-Stud$i -Template CE1 -VMHost $ESXiServer -Datastore $DataStore -ResourcePool Student-$i -RunAsync
        New-VM -Name CE2-Stud$i -Template CE2 -VMHost $ESXiServer -Datastore $DataStore -ResourcePool Student-$i -RunAsync
        New-VM -Name CE3-Stud$i -Template CE3 -VMHost $ESXiServer -Datastore $DataStore -ResourcePool Student-$i -RunAsync
        New-VM -Name CE4-Stud$i -Template CE4 -VMHost $ESXiServer -Datastore $DataStore -ResourcePool Student-$i -RunAsync
        # Windows AD
        New-VM -Name DC-Stud$i -Template DC-Templ -VMHost $ESXiServer -Datastore $DataStore -ResourcePool Student-$i
        #VyOS machine
        New-VM -Name VyOS-Stud$i -Template VyOS-Templ -VMHost $ESXiServer -Datastore $DataStore -ResourcePool Student-$i -RunAsync

        Start-Sleep -s 90

        # Change the other NICs of the VMs
        $oldnet="VM Network"
        $newnet="TempNetwork"
        Get-VM -Name *Stud$i |Get-NetworkAdapter |Where {$_.NetworkName -eq $oldnet } |Set-NetworkAdapter -NetworkName $newnet -Confirm:$false

        # Create the MAC addresses
        $Mac1="00:50:56:3F:FF:A$i" # VyOS MAC Address External Nic
    
        # Change VyOS NIC 0 to have a MAC we understand so DHCP will work; 
        # *****************************************************************************************************************
        # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! BEGIN REMARK !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        # *****************************************************************************************************************
        # Make sure this is the right one in the production environment. In test environment this is NIC 2; should be eth0
        get-vm -name "VyOS-Stud$i" | Get-NetworkAdapter -Name "Network adapter 1" | Set-NetworkAdapter -MacAddress $Mac1 -NetworkName 'VM Network'  -Confirm:$false
        # *****************************************************************************************************************
        # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! END REMARK !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        # *****************************************************************************************************************
        
        $oldnet="TempNetwork"
        $newnet="Student-$i"
        Get-VM -Name *Stud$i |Get-NetworkAdapter |Where {$_.NetworkName -eq $oldnet } |Set-NetworkAdapter -NetworkName $newnet -Confirm:$false
        
     }

    #Disconnect from the VMware environment
    disconnect-VIServer -force:$true -Confirm:$false -server *