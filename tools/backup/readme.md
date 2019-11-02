1. Reboot into recovery, enabling adb with root permissions:

   Hold the "Next/Page Down" Button while powering on your Boox to get into Fastboot mode, then run

   ```
   ../../../platform-tools/fastboot boot ../../recovery/recovery-twrp.img
   ```

   Or, if you already have installed the modified recovery image to flash, just use

   ```
   adb reboot recovery
   ```

2. Run a backup script:

   `./backup-auto.sh`: This script runs `sfdisk` on the device to determine the existing partitions, then uses the data from `blkid` to decide whether to create a file-based backup using `cpio` and `backup-filesystem.sh` or a simple partition dump using `backup-partition.sh`. Ext2/3/4 partition images will be resized to minimal size using `resize2fs` before gzipping.

   `./backup-mine.sh`: This script uses a list partition/filename pairs to operate on, running `backup-filesystem.sh` or `backup-partition.sh` depending on the filename.