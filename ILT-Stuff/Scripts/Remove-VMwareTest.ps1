# Load the VMware PowerCLI modules
Add-PSSnapin VMware.VimAutomation.Core


# Set Variables:
# This version just has all the variables at the top.
# These variables are HOST specific...
$vCenter = "192.168.81.100"
$vmhost=$vCenter
$VCUser="root"
$VCPassword="nutanix/4u"
$StudentsNr=2
$VMNumber=2

# Connect to the ESXi Server
connect-viserver -server $vCenter -User $VCUser -Password $VCPassword


# Remove the extra VirtualPortGroups of the student sessionsGet-VirtualPortGroup -Name TempNetwork | Remove-VirtualPortGroup -confirm:$false

# Try to get a dynamic number on machines to delete
# Fill an array with the names of the VMS that hold Student in them
$VMS=Get-VM | where {$_.Name -like "Student*"} | select Name 
# Get size of Array$Waarde=$vms.count/2#Remove VirtualPortGroupsfor ($i=1;$i -le $Waarde;$i++){    Get-VMHost | Get-VirtualSwitch -Name "vSwitch0" |
    Get-VirtualPortGroup -Name Student-$i | Remove-VirtualPortGroup -confirm:$false
    }# Remove the VMSfor($i=1;$i -lt $Waarde+1;$i++){    Remove-VM -VM Student-$i-VM1 -DeletePermanently -Confirm:$false
    Remove-VM -VM Student-$i-VM2 -DeletePermanently -Confirm:$false
    } 


# Disconnect-VIServer -force:$true -Confirm:$false -server *
