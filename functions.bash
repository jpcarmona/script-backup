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
# Creamos y copiamos - ficheros y directorios necesarios
mkdir -p /opt/sys-backup/backups-local /opt/sys-backup/snap-local
cp sys-backup.bash /opt/sys-backup/
cp functions.bash /opt/sys-backup/
touch /opt/sys-backup/dirs-backup-local
touch /opt/sys-backup/exc-dirs-backup-local
ln -s /opt/sys-backup/sys-backup.bash /usr/local/bin/sys-backup
chmod +x /usr/local/bin/sys-backup
}


function UNINSTALL_SYS-BACKUP_LOCAL
{
rm -rf /opt/sys-backup
rm -f /usr/local/bin/sys-backup
}


#function COMPROBAR_INSTALL_LOCAL
#{
## Comprobamos si existe el directorio /opt/sys-backup
#if [ ! -d /opt/sys-backup ]
#then
#  echo -e '\e[1;41m No existe el directorio "/opt/sys-backup" \e[0m'
#  echo -e '\e[1;41m Prueba instalando con "sys-backup local install" \e[0m'
#  exit 0
#fi
#}


function ADD_DIR_LOCAL
{
#COMPROBAR_INSTALL_LOCAL
# Añadimos descripción
echo "#$1 `date +%F`" >> dirs-backup-local
# Añadimos directorio a relizar copias
echo $2 >> dirs-backup-local

}


function ADD_EXC-DIR_LOCAL
{
#COMPROBAR_INSTALL_LOCAL
# Añadimos descripción
echo "#$1 `date +%F`" >> exc-dirs-backup-local
# Añadimos directorio a excluir copias
echo "--exclude=$2" >> exc-dirs-backup-local

}


#function COMPROBAR_BACKUP_VACIO
#{
## Comprobamos si ya se ha realizado algún backup
#if [ -z "$(ls /opt/sys-backup/backups)" ]
#then
#  echo -e '\e[1;41m No existen backups en "/opt/sys-backup/backups" \e[0m'
#  echo -e '\e[1;41m Prueba creando uno con "sys-backup local backup full" \e[0m'
#  exit 0
#fi
#}
#
#
#function COMPROBAR_DIRS-BACKUP-LOCAL_VACIO
#{
## Comprobamos si ya se ha realizado algún backup
#if [ -z "$(cat dirs-backup-local | grep -v "#" | tr -t "\n" " ")" ]
#then
#  echo -e '\e[1;41m No existen backups en "/opt/sys-backup/backups" \e[0m'
#  echo -e '\e[1;41m Prueba creando uno con "sys-backup local add-dir <descripción> <directorio>" \e[0m'
#  exit 0
#fi
#}


#function PLAN_BACKUPS_FULL_LOCAL
#{
#
#}
#
#function PLAN_BACKUPS_INC_LOCAL
#{
#
#}


function BACKUP-FULL_LOCAL
{
#COMPROBAR_INSTALL_LOCAL
#COMPROBAR_DIRS-BACKUP-LOCAL_VACIO
FECHA=$(date +%F)
# Directorios para el backup
DIRS_BACKUP=$(cat dirs-backup-local | grep -v "#" | tr -t "\n" " ")
# Directorios a excluir para el backup
EXC-DIRS_BACKUP=$(cat exc-dirs-backup-local | grep -v "#" | tr -t "\n" " ")
# Realizamos backup completo de $dirs-backup-local
if [ -z $EXC-DIRS_BACKUP ]
then
  tar -czvpf backups-local/full_$FECHA.tar.gz -g snap-local/full_$FECHA.snap $dirs-backup-local
else
  tar $EXC-DIRS_BACKUP -czvpf backups-local/full_$FECHA.tar.gz -g snap-local/full_$FECHA.snap $dirs-backup-local
fi

# Comprobar la planificación de backups
#PLAN_BACKUPS_FULL_LOCAL
}


function BACKUP-INC_LOCAL
{
#COMPROBAR_INSTALL_LOCAL
#COMPROBAR_BACKUP_VACIO
FECHA=$(date +%F)
# Directorios para el backup
DIRS_BACKUP=$(cat dirs-backup-local | grep -v "#" | tr -t "\n" " ")
# Directorios a excluir para el backup
EXC-DIRS_BACKUP=$(cat exc-dirs-backup-local | grep -v "#" | tr -t "\n" " ")
# Creamos nuevo snapshot copiando el último creado en "snap-local"
ULT_SNAP=$(ls -t snap-local | head -1)
cp snap-local/$ULT_SNAP snap-local/inc_$FECHA.snap
# Realizamos backup incremental de $dirs-backup-local
if [ -z $EXC-DIRS_BACKUP ]
then
  tar -czvpf backups-local/inc_$FECHA.tar.gz -g snap-local/inc_$FECHA.snap $dirs-backup-local
else
  tar $EXC-DIRS_BACKUP -czvpf backups-local/inc_$FECHA.tar.gz -g snap-local/inc_$FECHA.snap $dirs-backup-local
fi
# Comprobar la planificación de backups
#PLAN_BACKUPS_INC_LOCAL
}


## REMOTO

function ADD_DIR_REMOTE
{

echo "ADD_DIR_REMOTE"

}


function ADD_EXC-DIR_REMOTE
{
# Añadimos descripción
echo "#$1 `date +%F`" >> exc-dirs-backup-local
# Añadimos directorio a excluir copias
echo "--exclude=$2" >> exc-dirs-backup-local

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