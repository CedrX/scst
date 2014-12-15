SCSI Target to expose luns and tapes  to vms by ISCSI protocol

Le fichier scst-template.conf devra être placé dans le répertoire /etc
Copier le fichier make-scst.sh dans le répertoire /usr/local/bin (s'assurer qu'il soit exécutable par root chmod +x)

Exécuter la commande grep -q "/usr/local/bin/make-scstconf.sh" || cat append_to_etc_default_scst >> /etc/default/scst

