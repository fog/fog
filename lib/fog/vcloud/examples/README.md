# Using vCloud API via fog
_contributor @singhgarima_

For more information about fog [README](/README.md), or visit their website
[fog.io](http://fog.io).

## Vcloud API

Some useful links to get started on the vCloud API:

- [http://www.vmware.com/pdf/vcd_15_api_guide.pdf](http://www.vmware.com/pdf/vcd_15_api_guide.pdf)
- [vCloud API Programming Guide](http://pubs.vmware.com/vcd-51/index.jsp?topic=%2Fcom.vmware.vcloud.api.doc_51%2FGUID-86CA32C2-3753-49B2-A471-1CE460109ADB.html)

## Terminology

- Organization: An Organization is the fundamental vCloud Director grouping
  that contains users, the vApps that they create, and the resources the vApps
  use. It is a top-level container in a cloud that contains one or more
  Organization Virtual Data Centers (Org vDCs) and Catalog entities. It owns
  all the virtual resources for a cloud instance and can have many Org vDCs.[1]

- vApp: VMware vApp is a format for packaging and managing applications. A vApp
  can contain multiple virtual machines.[2]

- VM: A virtualized personal computer environment in which a guest
  operating system and associated application software can run. Multiple virtual
  machines can operate on the same managed host machine concurrently.[3]

- Catalogs & Catalog-Items: Catalog is used in organizations for storing content.
  Example: base images. Each item stored in catalog is referred as catalog item.

- vDC: Virtual Data Center. These are of two kinds provider vDCs (accessible to
  multiple organizations), and organization vDCs (accessible only by a given
  organization). In fog we refer to organization vDCs.

- Networks: You can setup various internal networks and assign various internal
  ip ranges to them

## What is the difference between a virtual appliance and a virtual machine?

A  virtual machine is a tightly isolated software container created to run on
virtualized platforms. It has four key virtualized resources (CPU, RAM,
Storage, and Networking); but requires the installation of an Operating System
and runs on one or more applications. A virtual appliance functions very much
like a virtual machine, possessing the four key characteristics of
compatibility, isolation, encapsulation, and hardware independence. However, a
virtual appliance contains a pre-installed, pre-configured Operating System
and an application stack optimized to provide a specific set of services.[3]

**References**

- [1] http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1026316
- [2] http://www.vmware.com/pdf/vsphere4/r40/vsp_40_admin_guide.pdf
- [3] http://www.vmware.com/technical-resources/virtualization-topics/virtual-appliances/faqs
