#!/bin/bash
set -e

TS=$(date +%d%m%Y-%H%M%S)

zip -r \
  osboot/farewell_backup_$TS.zip \
  osboot/bzImage \
  osboot/single.gz \
  osboot/multi.gz \
  osboot/farewell.iso

echo "Backup selesai"
