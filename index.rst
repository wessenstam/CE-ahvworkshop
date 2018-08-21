.. title:: Introduction to Acropolis Hypervisor using the free Community Edition of Nutanix

.. #DOING: Create the right listings id:2
 ----
 <https://github.com/wessenstam/CE-ahvworkshop/issues/22>
 Willem Essenstam
 willem@nutanix.com
.. #TODO: AFS, Import into AHV, Export from AHV id:3
 =======
 ----
 <https://github.com/wessenstam/CE-ahvworkshop/issues/23>
 Willem Essenstam
 willem@nutanix.com
.. #TODO: Create the right listings id:0
 ----
 <https://github.com/wessenstam/CE-ahvworkshop/issues/20>
 Willem Essenstam
 willem@nutanix.com

.. #TODO: Done VM and some modification of modules to show up right in the toctree id:17
 ----
 <https://github.com/wessenstam/CE-ahvworkshop/issues/26>
 Willem Essenstam
 willem@nutanix.com


.. toctree::
  :maxdepth: 2
  :caption: Basic Workshop
  :name: _basicworkshop
  :hidden:

  Storage_basic/storage_basic
  Network_Config/network_config
  VM/vm
  IO_Metric/io_metric
  VM_Clone/vm_clone
  Network_Visualization/network_viz
  AD_Integration/ad_integration
  SSP/ssp
  SSR/ssr
  ABS/abs

.. toctree::
  :maxdepth: 2
  :caption: Replication
  :name: _replication
  :hidden:

  Replication/replication

.. toctree::
  :maxdepth: 2
  :caption: Advance Workshop
  :name: _advworkshop
  :hidden:

  Advanced_Networking/adv_network
  Switch_add/switch_add
  VM_Script/vm_script
  VM_Clone_Script/vm_clone_script
  Import_into_AHV/import_into_ahv



.. _getting_started:


---------------
Getting Started
---------------

Welcome to the Nutanix Acropolis Hypervisor (AHV) based on Nutanix's CE version! This workbook provides self-paced instruction and exercises that introduce Nutanix AHV based on the CE version. You will work through multiple parts of what makes an AHV environment.

What's New
++++++++++

- Initial Version (6/27/18) Willlem Essenstam

Environmental overview
++++++++++++++++++++++

Th CE environment is a **free version** of the Nutanix software. It can be nested in an ESXi 6.0 U3 and up VMware environment or run as bare-metal. In our workshop we run the CE version as a nested VM in an isolated VLAN. You will be accessing this network via a RDP session to a Windows workstation on which all the needed tools are installed.

In each VLAN there are the following machines, IP addresses and their functions

=================== =============== ==================
Name of the machine IP Address      Function
=================== =============== ==================
DC-1                192.168.100.1   Domain Controller
WKS1                192.168.100.10  Workstation/RDP
AHV-CE1             192.168.100.21  AHV for CE-1
AHV-CE1             192.168.100.21  AHV for CE-1
AHV-CE1             192.168.100.21  AHV for CE-1
AHV-CE1             192.168.100.21  AHV for CE-1
CVM-CE1             192.168.100.31  CVM for CE-1
CVM-CE1             192.168.100.31  CVM for CE-1
CVM-CE1             192.168.100.31  CVM for CE-1
CVM-CE1             192.168.100.31  CVM for CE-1
VyOS                192.168.100.254 NAT and PAT Router
=================== =============== ==================

CE Information
++++++++++++++
To get access to the CE version click `here <https://www.nutanix.com/products/register/>`_. This link also allows you to use the CE version. Yes we still need a license, but there are **no costs** for that use...

.. note:: As there is a lot of information in the internet how to install Nutanix CE we will not cover that. If you want to know how to install it in a nested environment, please search google on Nested Nutanix CE and you'll find multiple sites. An example can be found `here <https://www.viktorious.nl/2018/05/03/run-nutanix-ce-nested-on-vmware-esxi-6-5-solving-some-of-the-challenges-you-will-face/>`_
