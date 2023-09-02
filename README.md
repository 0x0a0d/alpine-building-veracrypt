# README

This repository is used to build VeraCrypt on Alpine Linux.

## Build and Installation

To build VeraCrypt on Alpine Linux, follow these steps:

1. Clone or download this repository to your local machine.
2. Open a terminal and navigate to the repository's root directory.
3. Run the following command to initiate the build process:

   ```shell
   git clone https://github.com/0x0a0d/alpine-building-veracrypt.git
   cd alpine-building-veracrypt
   bash setup.sh
   ```

   This command will build the VeraCrypt Docker image using the provided `Dockerfile`.

4. Once the build process is complete, the installation file can be found at the following location relative to the repository's root directory:

   ```text
   ./build/veracrypt-[VERSION]-setup-console-x64
   ```

   Replace `[VERSION]` with the appropriate version number.

## Additional Steps for Alpine Linux

If you intend to use VeraCrypt on Alpine Linux, please follow these additional steps:

1. Install the necessary packages by running the following command:

   ```shell
   apk add tar fuse device-mapper
   ```

   This command will install the required packages for VeraCrypt to function properly on Alpine Linux.

2. Enable the fuse module by running the following command:

   ```shell
   modprobe fuse
   ```

   This command enables the fuse module, which is necessary for VeraCrypt to work correctly.

With these steps completed, you should now have VeraCrypt successfully installed and configured on Alpine Linux.

For further information and usage instructions, please refer to the documentation provided with the VeraCrypt package.
