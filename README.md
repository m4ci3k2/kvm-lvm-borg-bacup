# Synopsis

A simple script to backup KVM guests using borg backup 

# Initialization
borg init -e keyfile-blak2 --make-parent-dirs  /backup/$HOST
borg key export --qr-html /backup/$HOST $HOST.html
echo "Print and store $HOST.html"

# Usage
Just drop `kvm-backup.sh` to `cron-daily`.
Cron will send backup reports to you.
