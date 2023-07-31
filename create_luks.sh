#!/bin/bash

#SCRATCH_PATH="/scratch/users/lars.quentin01"
SCRATCH_PATH="/scratch-emmy/usr/gzadmhno/sc/"

CONTAINER_NAME=$(hostname) 
CONTAINER_FILE="${SCRATCH_PATH}/luks/${CONTAINER_NAME}.img"
PASSWORD_FILE="${SCRATCH_PATH}/password"
MOUNT_PATH="/data/esluks"

# image size is in megabytes
IMAGE_SIZE=$((1024 * 200))

# Load kernel module
mv /lib/modules/`uname -r`.dis-afterboot /lib/modules/`uname -r`
modprobe dm_crypt

# Clean up from before
# okay if this fails
echo "cleaning up from last time, ignore if it fails..."
umount $MOUNT_PATH
# TODO for now, delete from the losetup -l manually
cryptsetup luksClose /dev/mapper/$CONTAINER_NAME

# Check if the passowrd file exists
if [ ! -e "$PASSWORD_FILE" ]; then
  echo "WARNING: $PASSWORD_FILE does not exist!" >&2
  echo "Creating it with: "
  echo "dd if=/dev/urandom of="${PASSWORD_FILE}" bs=1 count=256"
  dd if=/dev/urandom of="${PASSWORD_FILE}" bs=1 count=256
else
  echo "Using Passowrd file ${PASSWORD_FILE}"
fi

# Find out whether the luks device was already created
if [ ! -e "${CONTAINER_FILE}" ]; then
  echo "WARNING: $CONTAINER_FILE does not exist!" >&2
  echo "Creating it with: "
  echo "dd if=/dev/zero of=${CONTAINER_FILE} bs=1M count=${IMAGE_SIZE}"
  dd if=/dev/zero of=${CONTAINER_FILE} bs=1M count=${IMAGE_SIZE}
else
  echo "Using container file ${CONTAINER_FILE}"
fi

# Mount our container as loopback
LOOP_DEV=$(losetup -f)
losetup $LOOP_DEV $CONTAINER_FILE
echo "mounting cryptsetup with:"
echo "cryptsetup -c aes-xts-plain -s 512 luksFormat $LOOP_DEV $PASSWORD_FILE"
# For some reason, it works best for me if we just do it three times :D
yes YES | cryptsetup -c aes-xts-plain -s 512 luksFormat $LOOP_DEV $PASSWORD_FILE
yes YES | cryptsetup -c aes-xts-plain -s 512 luksFormat $LOOP_DEV $PASSWORD_FILE
yes YES | cryptsetup -c aes-xts-plain -s 512 luksFormat $LOOP_DEV $PASSWORD_FILE
if [ $? -ne 0 ]; then
  echo "ERROR: Cryptsetup failed" >&2
  echo "Maybe just retry... maybe debug... who knows to be honest..." >&2
  echo "Maybe check whether it is double mounted with losetup -l ? That could be a problem." >&2
  exit 1
fi

# open the luks container
echo "Opening the LUKS container"
echo "cryptsetup luksOpen $LOOP_DEV $CONTAINER_NAME --key-file $PASSWORD_FILE"
cryptsetup luksOpen $LOOP_DEV $CONTAINER_NAME --key-file $PASSWORD_FILE

# make filesystem
echo "Creating a file system with"
echo "mkfs.ext4 /dev/mapper/$CONTAINER_NAME"
mkfs.ext4 /dev/mapper/$CONTAINER_NAME

# Mount the filesystem
mkdir -p $MOUNT_PATH
echo "Mounting with file system with"
echo "mount -t ext4 /dev/mapper/$CONTAINER_NAME $MOUNT_PATH"
mount -t ext4 /dev/mapper/$CONTAINER_NAME $MOUNT_PATH
