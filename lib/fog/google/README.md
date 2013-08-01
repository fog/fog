# Fog with Google

Fog currently supports two Google Cloud services: [Google Compute Engine](https://developers.google.com/compute/) and [Google Cloud Storage](https://developers.google.com/storage/). The main maintainer for the Google sections is @icco.

## Storage

Google Cloud Storage originally was very similar to Amazon's S3. Because of this, Fog implements the [XML GCS API](https://developers.google.com/storage/docs/xml-api-overview). We eventually want to move to the new [JSON API](https://developers.google.com/storage/docs/json_api/), once it has similar performance characteristics to the XML API. If this migration interests you, send us a pull request!

## Compute

Google Compute Engine is a Virtual Machine hosting service. Currently it is built on version [v1beta15](https://developers.google.com/compute/docs/reference/v1beta15/) of the GCE API.

Our implementation of the API currently supports 

 * Server creation, deletion and bootstrapping
 * All server "flavors" (micro and normal)
 * Persistent Disk creation and deletion
 * Image lookup

Features we are looking forward to implementing in the future:

 * Network and Firewall configuration
 * Global Metadata support
 * Image creation

v1beta15 is still in beta, so we can imagine lots of changes to the API. If you are using Fog to interact with GCE, please keep Fog up to date and [file issues](https://github.com/fog/fog/issues?labels=google) for any anomalies you see.

Thanks!
