# email-backups-with-duplicati
script to create a full backup of multiple mail accounts and create encrypted backups using duplicati.

The mail backup is stored in the "Maildir" format. Many applications are supporting this format e.g. [mutt](http://www.mutt.org/)

offlineimap is intentionally configured in "readonly" mode because we want to avoid any possible modification of our source data we want to backup...

## usage:
- **I highly recommend to read the bash scripts and understand them before you start.** It is not very complicated. You should consider this as a template to create your own custom setup for mail backups
- check if the offlineimap configuration file meets your needs (simple IMAP should basically work out of the box. GMail might require some additional configuration)
    - extend to fit your needs. This documentation was useful for me:
        - https://www.offlineimap.org/resources/
        - https://wiki.archlinux.org/title/OfflineIMAP
- set credentials and mail configurations as necessary in `secrets/pass_offlineimap.sh` and `secrets/pass_duplicati.sh`
- modify `scripts/collect_data_from_imap.sh` (e.g. to work with multiple mail accounts)
- modify `scripts/backup_data_using_duplicati.sh` to use the right duplicati cli command to store your backup
    - in this case I used MEGA.nz as storage provider
    - How to create your own duplicati-cli command (how I did it but you can consult the official documentation asn well):
        - create duplicati backup job by web ui
        - export the backup command with password
    - **Warning**: if your `$MEGA_USERNAME`, `$MEGA_PASSWORD`, or `$DUPLICATI_ENCRYPTION_PASSWORD` contain a `"` it might cause problems for you (bash escaping and so on)
- run `helper_download_data_and_create_backup.sh`
- maybe create a cronjob to run this regularly

### advanced usage:
- you can avoid the `duplicati-cli repair` step if you extend the docker command to mount a folder for the duplicati meta data (`/config`)
- Executing the "repair"-step has the advantage that this setup is kind of stateless (ignoring the pass.sh files for credentials). This has the disadvantage that if someone modifies / deletes your data you might not notice as easily.

## warning:
- the passwords are stored in **plaintext** in the `secrets/pass_*.sh` files
    - I recommend to apply further security measures to avoid someone stealing all your valuable mail credentials

## software requirements:
- docker
    - offlineimap and duplicati are running inside docker

## tools used for this small project:
- docker
- [offlineimap](https://github.com/OfflineIMAP/offlineimap)
    - the package is installed from the most recent fedora docker image -> it looks like the version you get installed is actually the [offlineimap3](https://github.com/OfflineIMAP/offlineimap3) version (which is the official "successor" using python3 instead of python2)
    - fedora docker image: https://hub.docker.com/_/fedora
- [duplicati](https://www.duplicati.com/)
    - official duplicati docker image: https://hub.docker.com/r/duplicati/duplicati/

# How to read Maildir files
- use `mutt`
- launch mutt with folders
    - `mutt -f /data/Inbox`
    - `mutt -f /data/Sent`

## alternative use `mbox` format
- use this tool to convert Maildir format to convert to `.mbox`
    - https://github.com/bluebird75/maildir2mbox
- you can directly open the Mails using Gnome Evolution