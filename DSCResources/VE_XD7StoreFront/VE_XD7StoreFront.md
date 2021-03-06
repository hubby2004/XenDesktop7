## XD7StoreFront

Creates or updates a StoreFront deployment with the required features installed and configured

### Syntax

```
XD7StoreFront [string]
{
    SiteId = [UInt64]
    [ HostBaseUrl = [String] ]
    [ Ensure = [String] { Present | Absent } ]
}
```

### Properties

* **SiteId**: Citrix StoreFront base url.
* **HostBaseUrl**: Citrix StoreFront host base url.
  * If not specified, this value defaults to http://localhost.
* **Ensure**: Whether the Storefront deployment should be added or removed.


### Configuration

```
Configuration XD7StoreFrontExample {
    Import-DscResource -ModuleName XenDesktop7
    XD7StoreFront XD7StoreFrontExample {
        SiteId = 1
        HostBaseUrl = 'http://localhost/'
        Ensure = 'Present'
    }
}
```
