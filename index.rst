.. title:: Introduction to Acropolis Hypervisor using the free Community Edition of Nutanix

.. toctree::
  :maxdepth: 2
  :caption: Image Configuration
  :name: _imageconf
  :hidden:

  Image_configuration

.. toctree::
  :maxdepth: 2
  :caption: Network Configuration
  :name: _networkconf
  :hidden:

 Network_Config

.. toctree::
  :maxdepth: 2
  :caption: Active Directory Integration
  :name: _adintegration
  :hidden:

  AD_Integratie

.. _getting_started:

---------------
Getting Started
---------------

Welcome to the Nutanix Acropolis Hypervisor (AHV) based on Nutanix's CE version! This workbook provides self-paced instruction and exercises that introduce Nutanix AHV based on the CE version. You will work through multiple parts of what makes an AHV environment.

What's New
++++++++++

- Initial Version (6/27/18)

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
To get access to the CE version 'click here <a href="https://www.nutanix.com/products/register/">'. This link also allows you to use the CE version. Yes we still need a license, but there are **no costs** for that use...

.. note:: As there is a lot of information in the internet how to install Nutanix CE we will not cover that. If you want to know how to install it in a nested environment, please search google on Nested Nutanix CE and you'll find multiple sites. 'An example <a href="https://www.viktorious.nl/2018/05/03/run-nutanix-ce-nested-on-vmware-esxi-6-5-solving-some-of-the-challenges-you-will-face/">'

**Partners** - Choose **My Nutanix Login**
