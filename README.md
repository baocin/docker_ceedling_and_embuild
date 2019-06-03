# docker_ceedling_and_embuild

This docker file is CI enabling releases and testing for projects using Nordic Semiconductor nRF-chips and Segger Embedded Studio project files. Unit testing is set up using the Ceedling/Cmock/Unity framefork from Throw the Switch.

Default versions used are:

- Embedded Studio v4.16
- Nordic SDK 15.2

To build a local image using for example a different SDK it is possible to set build arguments as the following example.

```
docker build . --build-arg SDK_DL=https://developer.nordicsemi.com/nRF5_SDK/nRF5_SDK_v12.x.x/nRF5_SDK_12.3.0_d7731ad.zip -t my_image
```

It is currently possible to change the Segger version and the nRF SDK version using the SES_DL and SDK_DL build arguments.