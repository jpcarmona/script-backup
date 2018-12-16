#!/bin/bash
#Nombre del archivo: functions.bash
#Fecha de creación: 15/12/18
#Autor: Juan Pedro Carmona Romero
#Descripción: Funciones para sistema de backups

function COMPROBAR_ROOT
{
  
USER_BACKUP=`whoami`

if [ "$USER_BACKUP" != "root" ]
then
  echo -e "\e[1;41m Debe de ser el usuario ROOT para ejecutar el script \e[0m "
  exit
fi

}


## LOCAL

function INSTALL_SYS-BACKUP_LOCAL
{
# Creamos directorios para copias y snapshots
mkdir -p /opt/sys-backup/backups /opt/sys-backup/snapshots
echo -e '\e[1;42m Creados los directorios "backups" y "snapshots" en "/opt/sys-backup/" \e[0m'
# Copiamos los scripts
cp sys-backup.bash /opt/sys-backup/
cp functions.bash /opt/sys-backup/
echo -e '\e[1;42m Copiados los scripts "sys-backup.bash" y "functions.bash" en "/opt/sys-backup/" \e[0m'
# Creamos el fichero en el que especificamos los directorios para los backups
touch /opt/sys-backup/dirs-backup
echo -e '\e[1;42m Creado el fichero "dirs-backup" en "/opt/sys-backup/" \e[0m'
# Para ejecutar el script
ln -s /opt/sys-backup/sys-backup.bash /usr/local/bin/sys-backup
chmod +x /usr/local/bin/sys-backup
echo -e '\e[1;42m Creado el enlace para ejecución en el sistema de "/opt/sys-backup/sys-backup.bash" en "/usr/local/bin/sys-backup" \e[0m'
}


function UNINSTALL_SYS-BACKUP_LOCAL
{
# Eliminamos directorio
rm -rf /opt/sys-backup
echo -e '\e[1;42m Eliminado directorio "/opt/sys-backup" \e[0m'
# Eliminamos enlace de script
rm -f /usr/local/bin/sys-backup
echo -e '\e[1;42m Eliminado enlace "/usr/local/bin/sys-backup" \e[0m'
}


function COMPROBAR_INSTALL_LOCAL
{
# Comprobamos si existe el directorio /opt/sys-backup
if [ ! -d /opt/sys-backup ]
then
  echo -e '\e[1;41m No existe el directorio "/opt/sys-backup" \e[0m'
  echo -e '\e[1;41m Prueba instalando con "sys-backup local install" \e[0m'
  exit 0
fi
}


function ADD_DIR_LOCAL
{
COMPROBAR_INSTALL_LOCAL
# Añadimos descripción
echo "$1 `date +%F`" >> dirs-backup
# Añadimos directorio a relizar copias
echo $2 >> dirs-backup

}


function COMPROBAR_BACKUP_VACIO
{
# Comprobamos si ya se ha realizado algún backup
if [ -z "$(ls /opt/sys-backup/backups)" ]
then
  echo -e '\e[1;41m No existen backups en "/opt/sys-backup/backups" \e[0m'
  echo -e '\e[1;41m Prueba creando uno con "sys-backup local backup full" \e[0m'
  exit 0
fi
}


function BACKUP-FULL_LOCAL
{
COMPROBAR_INSTALL_LOCAL
FECHA=$(date +%F)
# Directorios para el backup
DIRS_BACKUP=$(cat dirs-backup | grep -v "#" | tr -t "\n" " ")
# Realizamos backup completo de $dirs-backup
tar -czvpf backups/full_$FECHA.tar.gz -g snapshots/full_$FECHA.snap $DIRS-BACKUP

}


function BACKUP-INC_LOCAL
{
COMPROBAR_INSTALL_LOCAL
COMPROBAR_BACKUP_VACIO

}


## REMOTO

function INSTALL_SYS-BACKUP_REMOTE
{

echo "INSTALL_SYS-BACKUP_REMOTE"

}


function UNINSTALL_SYS-BACKUP_REMOTE
{
# Eliminamos directorio
rm -rf /opt/sys-backup
echo -e '\e[1;42m Eliminado directorio "/opt/sys-backup" \e[0m'
# Eliminamos enlace de script
rm -f /usr/local/bin/sys-backup
echo -e '\e[1;42m Eliminado enlace "/usr/local/bin/sys-backup" \e[0m'
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
#ls -w 1 -t /etc/ | head -1
#
#
#linea=$(grep "completa=" ola)
#sed -ri "s/$linea/completa=alli/g" config