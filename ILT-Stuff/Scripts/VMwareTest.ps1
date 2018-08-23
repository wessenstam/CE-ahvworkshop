# Load the VMware PowerCLI modules
Add-PSSnapin VMware.VimAutomation.Core


# Set Variables:
# This version just has all the variables at the top.
# These variables are HOST specific...
$vCenter = "192.168.81.100"
$vmhost=$vCenter
$VCUser="root"
$VCPassword="nutanix/4u"
$StudentsNr=6


# Connect to the ESXi Server
connect-viserver -server $vCenter -User $VCUser -Password $VCPassword


# Create the extra vSwitches one per student sessionfor ($i=1; $i -le $StudentsNr; $i++){    New-VirtualSwitch -Name Student-$i -VMHost $vmhost -Confirm:$false
    New-VirtualPortGroup -Name Student-$i -VirtualSwitch Student-$i -VLanId 100
    }

