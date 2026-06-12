How to Restore From the BackupIf you move to a new machine or need to restore your setup, follow these command steps:

1. Restore Repositories

Add the saved repositories back to your system:

```
while read -r name url; do
    flatpak remote-add --if-not-exists "$name" "$url"
done < flatpak-remotes.txt
```



2. Reinstall Applications
Reinstall all applications listed in your backup file automatically:


```
xargs flatpak install -y < flatpak-apps.txt
```

3. Restore User Data & Settings
Extract your configurations back into your user space:

```
tar -xzf flatpak-userdata.tar.gz -C "$HOME"
```

Automation (Optional)
You can automate this backup script to run every week using `cron`.

1. Open the cron editor: crontab -e
2. Add this line at the bottom to run the script every Sunday at 10:00 AM:0 10 * * SUN /path/to/flatpak-backup.sh
