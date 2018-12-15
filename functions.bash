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


function INSTALL_SYS-BACKUP
{
# Creamos directorios para copias y snapshots
mkdir -p $1/sys-backup/backups $1/sys-backup/snapshots
# Copiamos los scripts
cp sys-backup.bash $1/sys-backup/
cp functions.bash $1/sys-backup/
# Creamos el fichero en el que especificamos los directorios para los backups
touch $1/sys-backup/dirs-backup
# Para ejecutar el script
ln -s $1/sys-backup/sys-backup.bash /usr/local/bin/sys-backup
chmod +x /usr/local/bin/sys-backup
}

function ADD_DIR
{
# Añadimos descripción
echo "$2 `date +%F`" >> dirs-backup
echo $3 >> dirs-backup

}
