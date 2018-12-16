#!/bin/bash
#Nombre del archivo: functions.bash
#Fecha de creación: 15/12/18
#Autor: Juan Pedro Carmona Romero
#Descripción: Funciones para sistema de backups

# Directorio script (por si se ejcuta desde otro directorio)
SCRIPT=$(readlink -f $0)
DIR_BASE=`dirname $SCRIPT`

# Comprueba si se ejecuta como ROOT
function COMPROBAR_ROOT
{
  
USER_BACKUP=`whoami`

if [ "$USER_BACKUP" != "root" ]
then
  echo -e "\e[1;41m Debe de ser el usuario ROOT para ejecutar el script \e[0m "
  exit
fi

}


# Imprime ayuda
function GET_AYUDA
{
  
echo "ayuda"

}

## LOCAL

function INSTALL_SYS-BACKUP_LOCAL
{
# Creamos y copiamos - ficheros y directorios necesarios
mkdir -p /opt/sys-backup/backups-local /opt/sys-backup/snaps-local
cp $DIR_BASE/sys-backup.bash /opt/sys-backup/
cp $DIR_BASE/functions.bash /opt/sys-backup/
touch /opt/sys-backup/dirs-backup-local
touch /opt/sys-backup/exc-dirs-backup-local
ln -s /opt/sys-backup/sys-backup.bash /usr/local/bin/sys-backup
chmod +x /opt/sys-backup/sys-backup.bash
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
echo "#$1 `date +%F`" >> $DIR_BASE/dirs-backup-local
# Añadimos directorio a relizar copias
echo $2 >> $DIR_BASE/dirs-backup-local

}


function ADD_EXC-DIR_LOCAL
{
#COMPROBAR_INSTALL_LOCAL
# Añadimos descripción
echo "#$1 `date +%F`" >> $DIR_BASE/exc-dirs-backup-local
# Añadimos directorio a excluir copias
echo "--exclude=$2" >> $DIR_BASE/exc-dirs-backup-local

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
DIRS_BACKUP=$(cat $DIR_BASE/dirs-backup-local | grep -v "#" | tr -t "\n" " ")
# Directorios a excluir para el backup
EXC_DIRS_BACKUP=$(cat $DIR_BASE/exc-dirs-backup-local | grep -v "#" | tr -t "\n" " ")
# Realizamos backup completo de $dirs-backup-local
if [ -z $EXC_DIRS_BACKUP ]
then
  tar -czpf $DIR_BASE/backups-local/full_$FECHA.tar.gz -g $DIR_BASE/snaps-local/full_$FECHA.snap $DIRS_BACKUP
else
  tar $EXC_DIRS_BACKUP -czpf $DIR_BASE/backups-local/full_$FECHA.tar.gz -g $DIR_BASE/snaps-local/full_$FECHA.snap $DIRS_BACKUP
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
DIRS_BACKUP=$(cat $DIR_BASE/dirs-backup-local | grep -v "#" | tr -t "\n" " ")
# Directorios a excluir para el backup
EXC_DIRS_BACKUP=$(cat $DIR_BASE/exc-dirs-backup-local | grep -v "#" | tr -t "\n" " ")
# Creamos nuevo snapsshot copiando el último creado en "snaps-local"
ULT_snaps=$(ls -t $DIR_BASE/snaps-local | head -1)
cp $DIR_BASE/snaps-local/$ULT_snaps $DIR_BASE/snaps-local/inc_$FECHA.snap
# Realizamos backup incremental de $dirs-backup-local
if [ -z $EXC_DIRS_BACKUP ]
then
  tar -czpf $DIR_BASE/backups-local/inc_$FECHA.tar.gz -g $DIR_BASE/snaps-local/inc_$FECHA.snap $DIRS_BACKUP
else
  tar $EXC_DIRS_BACKUP -czpf $DIR_BASE/backups-local/inc_$FECHA.tar.gz -g $DIR_BASE/snaps-local/inc_$FECHA.snap $DIRS_BACKUP
fi
# Comprobar la planificación de backups
#PLAN_BACKUPS_INC_LOCAL
}


## REMOTO ##########
# Importante tener añadido manualmente los servidores remotos en el known hosts #
# y tener configuradas las claves públicas y privadas. #
####################

function ADD_DIR_REMOTE
{

# Añadimos descripción
echo "#$1 $2 `date +%F`" >> $DIR_BASE/dirs-backup-$1
# Añadimos directorio a relizar copias
echo $3 >> $DIR_BASE/dirs-backup-$1


}


function ADD_EXC-DIR_REMOTE
{
# Añadimos descripción
echo "#$1 $2 `date +%F`" >> $DIR_BASE/exc-dirs-backup-$1
# Añadimos directorio a excluir copias
echo "--exclude=$3" >> $DIR_BASE/exc-dirs-backup-$1

}


function BACKUP-FULL_REMOTE
{

#COMPROBAR_INSTALL_LOCAL
#COMPROBAR_DIRS-BACKUP-LOCAL_VACIO
FECHA=$(date +%F)
# Directorios para el backup
DIRS_BACKUP=$(cat $DIR_BASE/dirs-backup-$1 | grep -v "#" | tr -t "\n" " ")
# Directorios a excluir para el backup
EXC_DIRS_BACKUP=$(cat $DIR_BASE/exc-dirs-backup-$1 | grep -v "#" | tr -t "\n" " ")
# Realizamos backup completo de $dirs-backup-$1
if [ -z $EXC_DIRS_BACKUP ]
then
  COMM_REMOTE="tar -czpf - -g /tmp/temporal.snap $DIRS_BACKUP"
else
  COMM_REMOTE="tar $EXC_DIRS_BACKUP -czpf - -g /tmp/temporal.snap $DIRS_BACKUP"
fi

# Ejecutamos backup remoto
ssh root@$1 $COMM_REMOTE > $DIR_BASE/backups-$1/full_$FECHA.tar.gz
scp root@$1:/tmp/temporal.snap $DIR_BASE/snaps-$1/full_$FECHA.snap
ssh root@$1 "rm /tmp/temporal.snap"

# Comprobar la planificación de backups
#PLAN_BACKUPS_FULL_$1

}


function BACKUP-INC_REMOTE
{

#COMPROBAR_INSTALL_LOCAL
#COMPROBAR_BACKUP_VACIO
FECHA=$(date +%F)
# Directorios para el backup
DIRS_BACKUP=$(cat $DIR_BASE/dirs-backup-$1 | grep -v "#" | tr -t "\n" " ")
# Directorios a excluir para el backup
EXC_DIRS_BACKUP=$(cat $DIR_BASE/exc-dirs-backup-$1 | grep -v "#" | tr -t "\n" " ")
# Creamos nuevo snapsshot copiando el último creado en "snaps-local"
ULT_snaps=$(ls -t $DIR_BASE/snaps-$1 | head -1)
scp $DIR_BASE/snaps-$1/$ULT_snaps root@$1:/tmp/temporal.snap
# Realizamos backup incremental de $dirs-backup-local
if [ -z $EXC_DIRS_BACKUP ]
then
  COMM_REMOTE="tar -czpf - -g /tmp/temporal.snap $DIRS_BACKUP"
else
  COMM_REMOTE="tar $EXC_DIRS_BACKUP -czpf - -g /tmp/temporal.snap $DIRS_BACKUP"
fi

# Ejecutamos backup remoto
ssh root@$1 $COMM_REMOTE > $DIR_BASE/backups-$1/inc_$FECHA.tar.gz
scp root@$1:/tmp/temporal.snap $DIR_BASE/snaps-$1/inc_$FECHA.snap
ssh root@$1 "rm /tmp/temporal.snap"

# Comprobar la planificación de backups
#PLAN_BACKUPS_INC_LOCAL

}


# DEJAR POR SI ACASO
#linea=$(grep "completa=" ola)
#sed -ri "s/$linea/completa=alli/g" config