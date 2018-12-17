#!/bin/bash
#Nombre del archivo: functions.bash
#Fecha de creación: 15/12/18
#Autor: Juan Pedro Carmona Romero
#Descripción: Funciones para sistema de backups

## Directorio script (por si se ejcuta desde otro directorio)
SCRIPT=$(readlink -f $0)
DIR_BASE=`dirname $SCRIPT`

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

## LOCAL

## Creamos y copiamos - ficheros y directorios necesarios
function INSTALL_SYS-BACKUP
{
mkdir -p /opt/sys-backup/backups-local /opt/sys-backup/snaps-local /opt/sys-backup/dpkg
#echo -e '\e[1;42m Creados los directorios "backups", "snaps-local" y "dpkg" en "/opt/sys-backup/" \e[0m'
cp $DIR_BASE/sys-backup.bash /opt/sys-backup/
cp $DIR_BASE/functions.bash /opt/sys-backup/
#echo -e '\e[1;42m Copiados los scripts "sys-backup.bash" y "functions.bash" en "/opt/sys-backup/" \e[0m'
touch /opt/sys-backup/dirs-backup-local
touch /opt/sys-backup/exc-dirs-backup-local
#echo -e '\e[1;42m Creados los ficheros "dirs-backup-local" y "exc-dirs-backup-local" en "/opt/sys-backup/" \e[0m'
ln -s /opt/sys-backup/sys-backup.bash /usr/local/bin/sys-backup
#echo -e '\e[1;42m Creado el enlace para ejecución en el sistema de "/opt/sys-backup/sys-backup.bash" en "/usr/local/bin/sys-backup" \e[0m'
chmod +x /opt/sys-backup/sys-backup.bash
}


function UNINSTALL_SYS-BACKUP
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
## Añadimos descripción
echo "# $1 `date +%F`" >> /opt/sys-backup/dirs-backup-local
## Añadimos directorio a relizar copias
echo $1 >> /opt/sys-backup/opt/sys-backup/dirs-backup-local

}


function ADD_EXC-DIR_LOCAL
{
#COMPROBAR_INSTALL_LOCAL
## Añadimos descripción
echo "# $1 `date +%F`" >> /opt/sys-backup/exc-dirs-backup-local
## Añadimos directorio a excluir copias
echo "--exclude=$1" >> /opt/sys-backup/exc-dirs-backup-local

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
DIRS_BACKUP=$(cat /opt/sys-backup/dirs-backup-local | grep -v "#" | tr -t "\n" " ")
## Directorios a excluir para el backup
EXC_DIRS_BACKUP=$(cat /opt/sys-backup/exc-dirs-backup-local | grep -v "#" | tr -t "\n" " ")
## Realizamos backup completo de $dirs-backup-local
if [ -z $EXC_DIRS_BACKUP ]
then
  tar -czpf /opt/sys-backup/backups-local/full_$FECHA.tar.gz -g /opt/sys-backup/snaps-local/full_$FECHA.snap $DIRS_BACKUP
else
  tar $EXC_DIRS_BACKUP -czpf /opt/sys-backup/backups-local/full_$FECHA.tar.gz -g /opt/sys-backup/snaps-local/full_$FECHA.snap $DIRS_BACKUP
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
DIRS_BACKUP=$(cat /opt/sys-backup/dirs-backup-local | grep -v "#" | tr -t "\n" " ")
## Directorios a excluir para el backup
EXC_DIRS_BACKUP=$(cat /opt/sys-backup/exc-dirs-backup-local | grep -v "#" | tr -t "\n" " ")
## Creamos nuevo snapsshot copiando el último creado en "snaps-local"
ULT_snaps=$(ls -t /opt/sys-backup/snaps-local | head -1)
cp /opt/sys-backup/snaps-local/$ULT_snaps /opt/sys-backup/snaps-local/inc_$FECHA.snap
## Realizamos backup incremental de $dirs-backup-local
if [ -z $EXC_DIRS_BACKUP ]
then
  tar -czpf /opt/sys-backup/backups-local/inc_$FECHA.tar.gz -g /opt/sys-backup/snaps-local/inc_$FECHA.snap $DIRS_BACKUP
else
  tar $EXC_DIRS_BACKUP -czpf /opt/sys-backup/backups-local/inc_$FECHA.tar.gz -g /opt/sys-backup/snaps-local/inc_$FECHA.snap $DIRS_BACKUP
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
dpkg --get-selections > /opt/sys-backup/dpkg/dpkg-local_$FECHA

}


function RESTORE_DPKG_LOCAL
{

apt update
apt -y install dselect
dselect update
dpkg --set-selections < /opt/sys-backup/dpkg/dpkg-local_$1
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
BACKUPS=$(find /opt/sys-backup/backups-local -type f -newermt $FECHA_FULL ! -newermt $FECHA_FIN)

# Si se especifica fichero o directorio concreto en "$2" realiza solo restauración de ese, sino se realiza restauración completa #
if [ -z "$2" ]
then
  ## Antes que nada 
  RESTORE_DPKG_LOCAL $1
  for FICHERO in $BACKUPS
  do
    tar -xzpf /opt/sys-backup/backups-local/$FICHERO -C /
  done
else 
  FILE_TAR=$(echo $2 | cut -d "/" -f 2-)
  for FICHERO in $BACKUPS
  do
    tar -xzpf /opt/sys-backup/backups-local/$FICHERO -C / $FILE_TAR
  done
fi

}


## REMOTO ##########
# Importante tener añadido manualmente los servidores remotos en el known hosts, #
# tener configuradas las claves públicas y privadas en authorized_keys #
# y permitir el acceso mediante ROOT. #
####################

function ADD_DIR_REMOTE
{

## Añadimos descripción
echo "# $1 $2 `date +%F`" >> /opt/sys-backup/dirs-backup-$1
## Añadimos directorio a relizar copias
echo $2 >> /opt/sys-backup/dirs-backup-$1


}


function ADD_EXC-DIR_REMOTE
{
## Añadimos descripción
echo "# $1 $2 `date +%F`" >> /opt/sys-backup/exc-dirs-backup-$1
## Añadimos directorio a excluir copias
echo "--exclude=$2" >> /opt/sys-backup/exc-dirs-backup-$1

}


function BACKUP-FULL_REMOTE
{

#COMPROBAR_INSTALL_LOCAL
#COMPROBAR_DIRS-BACKUP-LOCAL_VACIO
FECHA=$(date +%F)
## Directorios para el backup
DIRS_BACKUP=$(cat /opt/sys-backup/dirs-backup-$1 | grep -v "#" | tr -t "\n" " ")
## Directorios a excluir para el backup
EXC_DIRS_BACKUP=$(cat /opt/sys-backup/exc-dirs-backup-$1 | grep -v "#" | tr -t "\n" " ")
## Realizamos backup completo de $dirs-backup-$1
if [ -z $EXC_DIRS_BACKUP ]
then
  COMM_REMOTE="tar -czpf - -g /tmp/temporal.snap $DIRS_BACKUP"
else
  COMM_REMOTE="tar $EXC_DIRS_BACKUP -czpf - -g /tmp/temporal.snap $DIRS_BACKUP"
fi

## Ejecutamos backup remoto
ssh root@$1 $COMM_REMOTE > /opt/sys-backup/backups-$1/full_$FECHA.tar.gz
scp root@$1:/tmp/temporal.snap /opt/sys-backup/snaps-$1/full_$FECHA.snap
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
DIRS_BACKUP=$(cat /opt/sys-backup/dirs-backup-$1 | grep -v "#" | tr -t "\n" " ")
# Directorios a excluir para el backup
EXC_DIRS_BACKUP=$(cat /opt/sys-backup/exc-dirs-backup-$1 | grep -v "#" | tr -t "\n" " ")
# Creamos nuevo snapsshot copiando el último creado en "snaps-local"
ULT_snaps=$(ls -t /opt/sys-backup/snaps-$1 | head -1)
scp /opt/sys-backup/snaps-$1/$ULT_snaps root@$1:/tmp/temporal.snap
# Realizamos backup incremental de $dirs-backup-local
if [ -z $EXC_DIRS_BACKUP ]
then
  COMM_REMOTE="tar -czpf - -g /tmp/temporal.snap $DIRS_BACKUP"
else
  COMM_REMOTE="tar $EXC_DIRS_BACKUP -czpf - -g /tmp/temporal.snap $DIRS_BACKUP"
fi

# Ejecutamos backup remoto
ssh root@$1 $COMM_REMOTE > /opt/sys-backup/backups-$1/inc_$FECHA.tar.gz
scp root@$1:/tmp/temporal.snap /opt/sys-backup/snaps-$1/inc_$FECHA.snap
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
## Añadimos directrio para backups remotos de $1
mkdir /opt/sys-backup/backups-$1
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
## Creamos lista de paquetes instalados
ssh root@$1 "dpkg --get-selections" > /opt/sys-backup/dpkg/dpkg-$1_$FECHA

}


function RESTORE_DPKG_REMOTE
{

ssh root@$1 "apt update && apt -y install dselect && dselect update"
ssh root@$1 "dpkg --set-selections" < /opt/sys-backup/dpkg/dpkg-$1_$2
ssh root@$1 "apt-get dselect-upgrade -y"

}

cat >> prueba2 < prueba.dpkg


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
BACKUPS=$(find /opt/sys-backup/backups-$1 -type f -newermt $FECHA_FULL ! -newermt $FECHA_FIN)

# Si se especifica fichero o directorio concreto en "$3" realiza solo restauración de ese, sino se realiza restauración completa #
if [ -z "$3" ]
then
  ## Restaura los paquetes instalados en HOST($1) con fecha "$2"
  RESTORE_DPKG_REMOTE $1 $2
  mkdir /tmp/temporal-backups
  for FICHERO in $BACKUPS
  do
    tar -xzpf /opt/sys-backup/backups-$1/$FICHERO -C /tmp/temporal-backups/
  done
  scp -r /tmp/temporal-backups/ root@$1:/
  rm -r /tmp/temporal-backups
else 
  FILE_TAR=$(echo $3 | cut -d "/" -f 2-)
  for FICHERO in $BACKUPS
  do
    tar -xzpf /opt/sys-backup/backups-$1/$FICHERO -C /tmp/temporal-backups/ $FILE_TAR
  done
  scp -r /tmp/temporal-backups/ root@$1:/
  rm -r /tmp/temporal-backups
fi

}