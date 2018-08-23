
# **********************************************************************************
# * Nutanix CE stuff to be done                                                    *
# **********************************************************************************
# This script is deleting the default storagepool and container in the CE version
# Then sets the names according to the IP-address and table in the workshop document

# Load the Nutanix modules
Add-PsSnapin NutanixCmdletsPSSnapin

# Set parameters
$NTNXUser="admin"
$NTNXPassword="nutanix/4u"

# Use the below parameter on Commandlets version 4.6 and higher..
$NTNXPwdSec=ConvertTo-SecureString -String $NTNXPassword -AsPlainText -Force

#$CVMS="10.204.24.161","10.204.24.163""10.204.24.165","10.204.24.167","10.204.24.169""10.204.24.171"
$CVM="10.204.24.173"
$CEid=10


foreach ($CVM in $CVMS){

    # Conncet to the first CVS
    Connect-NutanixCluster -Password $NTNXPwdSec -Server $CVM -UserName "admin" -AcceptInvalidSSLCerts -ForcedConnection
    
    # Delete default container(s)
    $CNTRID=Get-NTNXContainer | where {$_.name -like "default*"} | select id # Output is an array
    foreach($Cont in $CNTRID){
        Remove-NTNXContainer -Id $Cont
    }

    # Setting the parameters for the cluster correctly
    $ClusterID=Get-NTNXClusterInfo | select id
    $CEName="ce$CEid"
    write-host "CEname is"$CEName
    Set-NTNXCluster -Name $CEName -NameServers 8.8.8.8 -Id $ClusterID

    # Disconnect the session
    Disconnect-NTNXCluster * 
    $CEid ++
    # write-host "counter is on"$CEid
    #>

    #Wiping the variabels for next run
    $StoragePool=$null
    $ClusterID=$Null
    $CNTRID=$null
}
