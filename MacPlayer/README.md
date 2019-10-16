# Mac Player

This is a simple macOS application that uses AVPlayer to play HLS assets, with or without FairPlay protection.

**Mac Player is not a PlayKit sample** - it's intended as a diagnistics tool: a core Apple player that **doesn't** use PlayKit. 

## Usage

### Build

Open the Xcode project and build MacPlayer target on "My Mac". The only dependencies are on built-in Apple frameworks (Cocoa, Foundation, AVKit, AVFoundation).

### Prebuilt Binary

[Download here](https://dl.bintray.com/kaltura/tools/:MacPlayer.app.zip). Because the app is not signed for distribution, you need to manually approve it: after unzipping, ctrl-click (or right-click) the app bundle, select Open in the menu, and click the Open button. This step is only required once.

### Usage

When the app is launched, the following dialog shows:

![](dialog.png)

#### Primary fields

- **FairPlay Certificate**: the Apple-provided FairPlay certificate in Base64
- **License URL**: the URL of a license server, with any required parameters
- **Content URL**: URL of the asset to be played

If FairPlay Certificate and License URL are not provided, the content is assumed to be non-FairPlay, but an error will occur if it is.

#### DRM Server Protocol

By default, the player uses Kaltura's uDRM. In that case, leave Custom Data header blank and don't change Server Protocol.

There's another DRM server protocol supported: sending the SPC payload as an HTML form (form-urlencoded). When using this protocol, you may also set Custom Data Header.

#### Play

Click Play to start playing the content. Messages from the player (events, errors and warnings) are displayed on the right side of the window.

Each type of message is prefixed by an emoji:

- 😎 Normal flow (informative messages)
- ⚠️ Warning (a non-fatal error)
- ‼️ Fatal error (playback will stop)

Close the playback window to go back to the dialog to select another asset or change parameters.

### Sample Kaltura asset

Copy the below JSON to the clipboard and click Import. Then click Play.

```
{
  "url": "https://cdnapisec.kaltura.com/p/2222401/sp/2222401/playManifest/entryId/1_i18rihuv/flavorIds/1_nwoofqvr,1_3z75wwxi,1_exjt5le8,1_uvb3fyqs/deliveryProfileId/8642/protocol/https/format/applehttp/a.m3u8",
  "drm": [
    {
      "certificate": "MIIFETCCA/mgAwIBAgIISWLo8KcYfPMwDQYJKoZIhvcNAQEFBQAwfzELMAkGA1UEBhMCVVMxEzARBgNVBAoMCkFwcGxlIEluYy4xJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MTMwMQYDVQQDDCpBcHBsZSBLZXkgU2VydmljZXMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTYwMjAxMTY0NTQ0WhcNMTgwMjAxMTY0NTQ0WjCBijELMAkGA1UEBhMCVVMxKDAmBgNVBAoMH1ZJQUNPTSAxOCBNRURJQSBQUklWQVRFIExJTUlURUQxEzARBgNVBAsMClE5QU5HR0w4TTYxPDA6BgNVBAMMM0ZhaXJQbGF5IFN0cmVhbWluZzogVklBQ09NIDE4IE1FRElBIFBSSVZBVEUgTElNSVRFRDCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA2YmfdPWM86+te7Bbt4Ic6FexXwMeL+8AmExIj8jAaNxhKbfVFnUnuXzHOajGC7XDbXxsFbPqnErqjw0BqUoZhs+WVMy+0X4AGqHk7uRpZ4RLYganel+fqitL9rz9w3p41x8JfLV+lAej+BEN7zNeqQ2IsC4BxkViu1gA6K22uGsCAwEAAaOCAgcwggIDMB0GA1UdDgQWBBQK+Gmarl2PO3jtLP6A6TZeihOL3DAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFGPkR1TLhXFZRiyDrMxEMWRnAyy+MIHiBgNVHSAEgdowgdcwgdQGCSqGSIb3Y2QFATCBxjCBwwYIKwYBBQUHAgIwgbYMgbNSZWxpYW5jZSBvbiB0aGlzIGNlcnRpZmljYXRlIGJ5IGFueSBwYXJ0eSBhc3N1bWVzIGFjY2VwdGFuY2Ugb2YgdGhlIHRoZW4gYXBwbGljYWJsZSBzdGFuZGFyZCB0ZXJtcyBhbmQgY29uZGl0aW9ucyBvZiB1c2UsIGNlcnRpZmljYXRlIHBvbGljeSBhbmQgY2VydGlmaWNhdGlvbiBwcmFjdGljZSBzdGF0ZW1lbnRzLjA1BgNVHR8ELjAsMCqgKKAmhiRodHRwOi8vY3JsLmFwcGxlLmNvbS9rZXlzZXJ2aWNlcy5jcmwwDgYDVR0PAQH/BAQDAgUgMEgGCyqGSIb3Y2QGDQEDAQH/BDYBZ2diOGN5bXpsb21vdXFqb3p0aHg5aXB6dDJ0bThrcGdqOGNwZGlsbGVhMWI1aG9saWlyaW8wPQYLKoZIhvdjZAYNAQQBAf8EKwF5aHZlYXgzaDB2Nno5dXBqcjRsNWVyNm9hMXBtam9zYXF6ZXdnZXFkaTUwDQYJKoZIhvcNAQEFBQADggEBAIaTVzuOpZhHHUMGd47XeIo08E+Wb5jgE2HPsd8P/aHwVcR+9627QkuAnebftasV/h3FElahzBXRbK52qIZ/UU9nRLCqqKwX33eS2TiaAzOoMAL9cTUmEa2SMSzzAehb7lYPC73Y4VQFttbNidHZHawGp/844ipBS7Iumas8kT8G6ZmIBIevWiggd+D5gLdqXpOFI2XsoAipuxW6NKnnlKnuX6aNReqzKO0DmQPDHO2d7pbd3wAz5zJmxDLpRQfn7iJKupoYGqBs2r45OFyM14HUWaC0+VSh2PaZKwnSS8XXo4zcT/MfEcmP0tL9NaDfsvIWnScMxHUUTNNsZIp3QXA=",
      "licenseURL": "https://udrmv3.kaltura.com/fps/license?custom_data=eyJjYV9zeXN0ZW0iOiJPVlAiLCJ1c2VyX3Rva2VuIjoiZGpKOE1qSXlNalF3TVh6VlliX2pYYVFCUzd6VF9XZEdERW54MkpQbU5HVmNsYlVQWWhwenFCLUJJOTdod1Y5ekxGdG9hY1ZTM0J3bnV4cDBiZUhVa2x1WXd5MHp4MTRSRUxzU3VkR2s2cXVLS2FsRDJqWTcycC1CZGc9PSIsImFjY291bnRfaWQiOiIyMjIyNDAxIiwiY29udGVudF9pZCI6IjFfaTE4cmlodXYiLCJmaWxlcyI6IjFfbndvb2ZxdnIsMV8zejc1d3d4aSwxX2V4anQ1bGU4LDFfdXZiM2Z5cXMifQ%3D%3D&signature=Dhi6sWjfjWAsydjex5ExcigSIms%3D",
      "objectType": "KalturaFairPlayPlaybackPluginData"
    }
  ]
}
```


