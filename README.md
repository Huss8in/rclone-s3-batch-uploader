# s3_rclone

## Overview

This project provides a **Windows batch script** that recursively uploads all files and subdirectories from a given local directory to an AWS S3 bucket using [`rclone`](https://rclone.org/). It includes robust **error handling and retry logic** to ensure reliable uploads.

---

## Requirements

- **Windows OS**
- **rclone** installed and configured with your AWS S3 remote
  - Example remote name in `rclone config`: `myaws`
  - Example usage: `myaws:s3bucket`

---

## Usage

```bash
upload_to_s3.bat [local_directory] [rclone_remote]
