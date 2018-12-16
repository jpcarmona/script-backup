#!/bin/bash
#Nombre del archivo: functions.bash
#Fecha de creación: 15/12/18
#Autor: Juan Pedro Carmona Romero
#Descripción: Funciones para sistema de backups

function COMPROBAR_ROOT
{
  
USER_BAKCUP=`whoami`

if [ "$USER_BACKUP" != "root" ]
then
  echo -e "\e[1;42m Debe de ser el usuario ROOT para ejecutar el script \e[0m "
  exit
fi

}


## LOCAL

function INSTALL_SYS-BACKUP_LOCAL
{
# Creamos directorios para copias y snapshots
mkdir -p /opt/sys-backup/backups /opt/sys-backup/snapshots
# Copiamos los scripts
cp sys-backup.bash /opt/sys-backup/
cp functions.bash /opt/sys-backup/
# Creamos el fichero en el que especificamos los directorios para los backups
touch /opt/sys-backup/dirs-backup
# Para ejecutar el script
ln -s /opt/sys-backup/sys-backup.bash /usr/local/bin/sys-backup
chmod +x /usr/local/bin/sys-backup
}

function ADD_DIR_LOCAL
{
# Añadimos descripción
echo "$1 `date +%F`" >> dirs-backup
# Añadimos directorio a relizar copias
echo $2 >> dirs-backup

}


function BACKUP-FULL_LOCAL
{

echo "BACKUP-FULL_LOCAL"

}


function BACKUP-INC_LOCAL
{

echo "BACKUP-FULL_LOCAL"

}


## REMOTO

function INSTALL_SYS-BACKUP_REMOTE
{

echo "INSTALL_SYS-BACKUP_REMOTE"

}

function ADD_DIR_REMOTE
{

echo "ADD_DIR_REMOTE"

}


function BACKUP-FULL_REMOTE
{

echo "BACKUP-FULL_REMOTE"

}


function BACKUP-INC_REMOTE
{

echo "BACKUP-INC_REMOTE"

}


# DEJAR POR SI ACASO
ls -w 1 -t /etc/ | head -1


linea=$(grep "completa=" ola)
sed -ri "s/$linea/completa=alli/g" config