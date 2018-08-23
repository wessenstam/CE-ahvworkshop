﻿# Load the VMware PowerCLI modules
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


# Remove the extra VirtualPortGroups of the student sessions

# Try to get a dynamic number on machines to delete
# Fill an array with the names of the VMS that hold Student in them
$VMS=Get-VM | where {$_.Name -like "Student*"} | select Name 
# Get size of Array
    Get-VirtualPortGroup -Name Student-$i | Remove-VirtualPortGroup -confirm:$false
    }
    Remove-VM -VM Student-$i-VM2 -DeletePermanently -Confirm:$false
    } 


# Disconnect-VIServer -force:$true -Confirm:$false -server *