#!/bin/bash
#Nombre del archivo: functions.bash
#Fecha de creación: 15/12/18
#Autor: Juan Pedro Carmona Romero
#Descripción: Funciones para sistema de backups

## Comprueba si se ejecuta como ROOT
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
  
echo "Ejemplo de uso de sys-backup"
echo ""
echo "sys-backup install"
echo "-- Instala sys-backup en el sistema --"
echo ""
echo "sys-backup uninstall"
echo "-- Desinstala sys-backup en el sistema --"
echo ""
echo "sys-backup local add-dir <Descripción> <Directorio>"
echo "-- Añade un directorio para las copias de seguridad locales --"
echo ""
echo "sys-backup local exc-dir <Descripción> <Directorio>"
echo "-- Excluye un directorio para las copias de seguridad locales --"
echo ""
echo "sys-backup local backup full"
echo "-- Realiza una copia de seguridad completa local --"
echo ""
echo "sys-backup local backup inc"
echo "-- Realiza una copia de seguridad incremental local --"
echo ""
echo "sys-backup remote <HOST> add-dir <Descripción> <Directorio>"
echo "-- Añade un directorio para las copias de seguridad remotas --"
echo ""
echo "sys-backup remote <HOST> exc-dir <Descripción> <Directorio>"
echo "-- Excluye un directorio para las copias de seguridad remotas --"
echo ""
echo "sys-backup remote <HOST> backup full"
echo "-- Realiza una copia de seguridad completa remota --"
echo ""
echo "sys-backup remote <HOST> backup inc"
echo "-- Realiza una copia de seguridad incremental remota --"
echo ""

}

## DIRECTORIO BACKUPS
PATH_BACKUPS=$PATH_BACKUPS

## LOCAL

## Creamos y copiamos - ficheros y directorios necesarios
function INSTALL_SYS-BACKUP
{
# Directorios Backups
mkdir -p $PATH_BACKUPS/backups $PATH_BACKUPS/snaps $PATH_BACKUPS/list-pkgs $PATH_BACKUPS/dir-backups
}


function UNINSTALL_SYS-BACKUP
{
rm -rf /opt/sys-backup
rm -f /usr/local/bin/sys-backup
LINEAS_CRON=$(cat /etc/crontab | grep "sys-backup")
for LINEA in $LINEAS_CRON
do
  sed -i "/$LINEA/d" /etc/crontab
done
}


## Creamos - ficheros y directorios necesarios
function INSTALL_SYS-BACKUP_LOCAL
{
mkdir $PATH_BACKUPS/backups/local
mkdir $PATH_BACKUPS/snaps/local
mkdir $PATH_BACKUPS/list-pkgs/local
touch $PATH_BACKUPS/dir-backups/local
touch $PATH_BACKUPS/dir-backups/exc-local
}

function ADD_DIR_LOCAL
{
#COMPROBAR_INSTALL_LOCAL
## Añadimos descripción
echo "# $1 `date +%F`" >> $PATH_BACKUPS/dir-backups/local
## Añadimos directorio a relizar copias
echo $1 >> $PATH_BACKUPS/dir-backups/local

}
### Arreglar para que no permita meter 2 veces el mismo directorio ###


function ADD_EXC-DIR_LOCAL
{
#COMPROBAR_INSTALL_LOCAL
## Añadimos descripción
echo "# $1 `date +%F`" >> $PATH_BACKUPS/dir-backups/exc-local
## Añadimos directorio a excluir copias
echo "--exclude=$1" >> $PATH_BACKUPS/dir-backups/exc-local

}

#function PLAN_BACKUPS_FULL
#{
#
#}
#
#function PLAN_BACKUPS_INC
#{
#
#}


function BACKUP-FULL_LOCAL
{
#COMPROBAR_INSTALL_LOCAL
#COMPROBAR_DIRS-BACKUP-LOCAL_VACIO
FECHA=$(date +%F)
## Directorios para el backup
DIRS_BACKUP=$(cat $PATH_BACKUPS/dir-backups/local | grep -v "#" | tr -t "\n" " ")
## Directorios a excluir para el backup
EXC_DIRS_BACKUP=$(cat $PATH_BACKUPS/dir-backups/exc-local | grep -v "#" | tr -t "\n" " ")
## Realizamos backup completo de $dirs-backup-local
if [ -z $EXC_DIRS_BACKUP ]
then
  tar -czpf $PATH_BACKUPS/backups/local/full_$FECHA.tar.gz -g $PATH_BACKUPS/snaps/local/full_$FECHA.snap $DIRS_BACKUP
else
  tar $EXC_DIRS_BACKUP -czpf $PATH_BACKUPS/backups/local/full_$FECHA.tar.gz -g $PATH_BACKUPS//snaps/local/full_$FECHA.snap $DIRS_BACKUP
fi

## Comprobar la planificación de backups
#PLAN_BACKUPS_FULL local
}


function BACKUP-INC_LOCAL
{
#COMPROBAR_INSTALL_LOCAL
#COMPROBAR_BACKUP_VACIO
FECHA=$(date +%F)
## Directorios para el backup
DIRS_BACKUP=$(cat $PATH_BACKUPS/dir-backups/local | grep -v "#" | tr -t "\n" " ")
## Directorios a excluir para el backup
EXC_DIRS_BACKUP=$(cat $PATH_BACKUPS/dir-backups/exc-local | grep -v "#" | tr -t "\n" " ")
## Creamos nuevo snapsshot copiando el último creado en "snaps-local"
ULT_SNAP=$(ls -t $PATH_BACKUPS/snaps/local | head -1)
cp $PATH_BACKUPS/snaps/local/$ULT_SNAP $PATH_BACKUPS/snaps/local/inc_$FECHA.snap
## Realizamos backup incremental de $dirs-backup-local
if [ -z $EXC_DIRS_BACKUP ]
then
  tar -czpf $PATH_BACKUPS/backups/local/inc_$FECHA.tar.gz -g $PATH_BACKUPS/snaps/local/inc_$FECHA.snap $DIRS_BACKUP
else
  tar $EXC_DIRS_BACKUP -czpf $PATH_BACKUPS/backups/local/inc_$FECHA.tar.gz -g $PATH_BACKUPS/snaps/local/inc_$FECHA.snap $DIRS_BACKUP
fi
## Comprobar la planificación de backups
#PLAN_BACKUPS_INC local
}


function CRON_BACKUP_LOCAL
{
## Día de la semana en número ("1" es Lunes)
FECHA_DIA=$(date +%u)
## Comprobamos si es Domingo
if [ $FECHA_DIA -eq 7 ]
then
  BACKUP-FULL_LOCAL
else
  BACKUP-INC_LOCAL
fi

BACKUP_DPKG_LOCAL
}


function ADD-CRON_LOCAL
{
## Añadimos al crontab la ejecución del backup todos los dias a las "01:01"
echo "1 1 * * * root sys-backup local cron-backup # sys-backup local" >> /etc/crontab
}


function DEL-CRON_LOCAL
{

## Quitamos la línea en crontab que ejecuta los backups
LINEA_CRON=$(grep "sys-backup local" /etc/crontab)
sed -i "/$LINEA_CRON/d" /etc/crontab
}


function BACKUP_DPKG_LOCAL
{
FECHA=$(date +%F)
## Creamos lista de paquetes instalados
dpkg --get-selections > $PATH_BACKUPS/list-pkgs/local/$FECHA

}


function RESTORE_DPKG_LOCAL
{

apt update
apt -y install dselect
dselect update
dpkg --set-selections < $PATH_BACKUPS/list-pkgs/local/$1
apt-get dselect-upgrade -y

}


function RESTORE_LOCAL
{
# "$1" es la fecha en la que se quiere restaurar
# Número de dias desde el backup completo
DIAS=$(date -d "$1" +%u)
# Añadimos un día para poder realizar bien el find
FECHA_FIN=$(date -d "$1 +1 day" +%F)

# Fecha del backup full
if [ $DIAS -eq 7 ]
then
  FECHA_FULL=$1
else
  FECHA_FULL=$(date -d "$1 -$DIAS day" +%F)
fi

# Ficheros de backups para la fecha dada
BACKUPS=$(find $PATH_BACKUPS/backups/local -type f -newermt $FECHA_FULL ! -newermt $FECHA_FIN)

# Si se especifica fichero o directorio concreto en "$2" realiza solo restauración de ese, sino se realiza restauración completa #
if [ -z "$2" ]
then
  ## Antes que nada 
  RESTORE_DPKG_LOCAL $1
  for FICHERO in $BACKUPS
  do
    tar -xzpf $FICHERO -C /
  done
else 
  FILE_TAR=$(echo $2 | cut -d "/" -f 2-)
  for FICHERO in $BACKUPS
  do
    tar -xzpf $FICHERO -C / $FILE_TAR
  done
fi

}


## REMOTO ##########
# Importante tener añadido manualmente los servidores remotos en el known hosts, #
# tener configuradas las claves públicas y privadas en authorized_keys #
# y permitir el acceso mediante ROOT. #
####################

## Creamos - ficheros y directorios necesarios
function INSTALL_SYS-BACKUP_REMOTE
{
mkdir $PATH_BACKUPS/backups/$1
mkdir $PATH_BACKUPS/snaps/$1
mkdir $PATH_BACKUPS/list-pkgs/$1
touch $PATH_BACKUPS/dir-backups/$1
touch $PATH_BACKUPS/dir-backups/exc-$1
}

function ADD_DIR_REMOTE
{

## Añadimos descripción
echo "# $1 $2 `date +%F`" >> $PATH_BACKUPS/dir-backups/$1
## Añadimos directorio a relizar copias
echo $2 >> $PATH_BACKUPS/dir-backups/$1


}


function ADD_EXC-DIR_REMOTE
{
## Añadimos descripción
echo "# $1 $2 `date +%F`" >> $PATH_BACKUPS/dir-backups/exc-$1
## Añadimos directorio a excluir copias
echo "--exclude=$2" >> $PATH_BACKUPS/dir-backups/exc-$1

}


function BACKUP-FULL_REMOTE
{

#COMPROBAR_INSTALL_LOCAL
#COMPROBAR_DIRS-BACKUP-LOCAL_VACIO
FECHA=$(date +%F)
## Directorios para el backup
DIRS_BACKUP=$(cat $PATH_BACKUPS/dir-backups/$1 | grep -v "#" | tr -t "\n" " ")
## Directorios a excluir para el backup
EXC_DIRS_BACKUP=$(cat $PATH_BACKUPS/dir-backups/exc-$1 | grep -v "#" | tr -t "\n" " ")
## Realizamos backup completo de $dirs-backup-$1
if [ -z $EXC_DIRS_BACKUP ]
then
  COMM_REMOTE="tar -czpf - -g /tmp/temporal.snap $DIRS_BACKUP"
else
  COMM_REMOTE="tar $EXC_DIRS_BACKUP -czpf - -g /tmp/temporal.snap $DIRS_BACKUP"
fi

## Ejecutamos backup remoto
ssh root@$1 $COMM_REMOTE > $PATH_BACKUPS/backups/$1/full_$FECHA.tar.gz
scp root@$1:/tmp/temporal.snap $PATH_BACKUPS/snaps/$1/full_$FECHA.snap
ssh root@$1 "rm /tmp/temporal.snap"

## Comprobar la planificación de backups
#PLAN_BACKUPS_FULL $1

}


function BACKUP-INC_REMOTE
{

#COMPROBAR_INSTALL_LOCAL
#COMPROBAR_BACKUP_VACIO
FECHA=$(date +%F)
# Directorios para el backup
DIRS_BACKUP=$(cat $PATH_BACKUPS/dir-backups/$1 | grep -v "#" | tr -t "\n" " ")
# Directorios a excluir para el backup
EXC_DIRS_BACKUP=$(cat $PATH_BACKUPS/dir-backups/exc-$1 | grep -v "#" | tr -t "\n" " ")
# Creamos nuevo snapsshot copiando el último creado en "snaps-local"
ULT_SNAP=$(ls -t $PATH_BACKUPS/snaps/$1 | head -1)
scp $PATH_BACKUPS/snaps/$1/$ULT_SNAP root@$1:/tmp/temporal.snap
# Realizamos backup incremental de $dirs-backup-local
if [ -z $EXC_DIRS_BACKUP ]
then
  COMM_REMOTE="tar -czpf - -g /tmp/temporal.snap $DIRS_BACKUP"
else
  COMM_REMOTE="tar $EXC_DIRS_BACKUP -czpf - -g /tmp/temporal.snap $DIRS_BACKUP"
fi

# Ejecutamos backup remoto
ssh root@$1 $COMM_REMOTE > $PATH_BACKUPS/backups/$1/inc_$FECHA.tar.gz
scp root@$1:/tmp/temporal.snap $PATH_BACKUPS/snaps/$1/inc_$FECHA.snap
ssh root@$1 "rm /tmp/temporal.snap"

# Comprobar la planificación de backups
#PLAN_BACKUPS_INC $1

}


function CRON_BACKUP_REMOTE
{
## Día de la semana en número ("1" es Lunes)
FECHA_DIA=$(date +%u)
## Comprobamos si es Domingo
if [ $FECHA_DIA -eq 7 ]
then
  BACKUP-FULL_REMOTE $1
else
  BACKUP-INC_REMOTE $1
fi

BACKUP_DPKG_REMOTE $1
}


function ADD-CRON_REMOTE
{
## Añadimos al crontab la ejecución del backup todos los dias a las "01:01"
echo "1 1 * * * root sys-backup remote $1 cron-backup # sys-backup $1" >> /etc/crontab
}


function DEL-CRON_REMOTE
{

## Quitamos la línea en crontab que ejecuta los backups
LINEA_CRON=$(grep "sys-backup $1" /etc/crontab)
sed -i "/$LINEA_CRON/d" /etc/crontab
}


function BACKUP_DPKG_REMOTE
{
FECHA=$(date +%F)
# Variable para comprobar que tipo de distribuición es
SYSTEM-OS=$(ssh root@$1 "cat /etc/os-release")

## Creamos lista de paquetes instalados
if [ $( echo $SYSTEM-OS | grep debian) ]
then
  ssh root@$1 "dpkg --get-selections" > $PATH_BACKUPS/list-pkgs/$1/$FECHA
elif [ $( echo $SYSTEM-OS | grep centos)  ]
then
  ssh root@$1 "rpm -qa" > $PATH_BACKUPS/list-pkgs/$1/$FECHA
  sed -i 's/^/install /' $PATH_BACKUPS/list-pkgs/$1/$FECHA
  echo run >> $PATH_BACKUPS/list-pkgs/$1/$FECHA
fi

}


function RESTORE_DPKG_REMOTE
{
# Variable para comprobar que tipo de distribuición es
SYSTEM-OS=$(ssh root@$1 "cat /etc/os-release")

if [ $( echo $SYSTEM-OS | grep debian) ]
then
  ssh root@$1 "apt update && apt -y install dselect && dselect update"
  ssh root@$1 "dpkg --set-selections" < $PATH_BACKUPS/list-pkgs/$1/$2
  ssh root@$1 "apt-get dselect-upgrade -y"
elif [ $( echo $SYSTEM-OS | grep centos)  ]
then
  ssh root@$1 "yum shell" < $PATH_BACKUPS/list-pkgs/$1/$2
fi

}

function RESTORE_REMOTE
{
# "$1" es la fecha en la que se quiere restaurar
# Número de dias desde el backup completo
DIAS=$(date -d "$2" +%u)
# Añadimos un día para poder realizar bien el find
FECHA_FIN=$(date -d "$2 +1 day" +%F)

# Fecha del backup full
if [ $DIAS -eq 7 ]
then
  FECHA_FULL=$2
else
  FECHA_FULL=$(date -d "$2 -$DIAS day" +%F)
fi

# Ficheros de backups para la fecha dada
BACKUPS=$(find $PATH_BACKUPS/backups/$1 -type f -newermt $FECHA_FULL ! -newermt $FECHA_FIN)

# Si se especifica fichero o directorio concreto en "$3" realiza solo restauración de ese, sino se realiza restauración completa #
if [ -z "$3" ]
then
  ## Restaura los paquetes instalados en HOST($1) con fecha "$2"
  RESTORE_DPKG_REMOTE $1 $2
  mkdir /tmp/temporal-backups
  for FICHERO in $BACKUPS
  do
    tar -xzpf $FICHERO -C /tmp/temporal-backups/
  done
  scp -r /tmp/temporal-backups/ root@$1:/
  rm -r /tmp/temporal-backups
else 
  FILE_TAR=$(echo $3 | cut -d "/" -f 2-)
  for FICHERO in $BACKUPS
  do
    tar -xzpf $FICHERO -C /tmp/temporal-backups/ $FILE_TAR
  done
  scp -r /tmp/temporal-backups/ root@$1:/
  rm -r /tmp/temporal-backups
fi

}