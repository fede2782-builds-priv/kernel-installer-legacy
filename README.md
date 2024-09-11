# Simple kernel installer

This is a simple kernel installer for legacy system-as-root devices, both A/B and A-only are supported.

Only kernel executable change is supported, thanks to Magiskboot this allows to keep stock dtb, dtbo, recovery (on A/B) and ramdisk.

Moreover this will place a addon.d file if the ROM supports it in the /system/addon.d/ directory to keep the kernel during OTA updates, currently implemented only for A/B but I plan to add support also for A-only in the near future. 

## Building

Adapt the values in config.sh file to your needs. 

On Windows, place the kernel executable named as `Image` just select all file and ZIP file using built-in zip function or by using 7-zip with default compression level.

On Linux just use the `zip` command part of the `zip` in Debian-based distros, run the following in the repository after copying the kernel image as `Image`. 

```bash
zip -r output-flashable.zip *
```

## Credits

- [Magisk](https://github.com/topjohnwu/Magisk) for `magiskboot` utility and `busybox` prebuilt for arm64-v8a.
- [MindTheGapps](https://gitlab.com/MindTheGapps/vendor_gapps) for a few functions for recovery installer script.
