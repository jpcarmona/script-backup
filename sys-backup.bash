#!/bin/bash
#Nombre del archivo: sys-backup.bash
#Fecha de creación: 15/12/18
#Autor: Juan Pedro Carmona Romero
#Descripción: Script principal para sistema de backups

# Directorio script (por si se ejcuta desde otro directorio)
SCRIPT=$(readlink -f $0)
DIR_BASE=`dirname $SCRIPT`

# Cargamos funciones
. $DIR_BASE/functions.bash

# Comprobamos si somos ROOT
COMPROBAR_ROOT


case $1 in
  local)
    case $2 in
      # Ejecuta instalación del script en el sistema en "/opt/sys-backup"
      install)
        INSTALL_SYS-BACKUP_LOCAL
        ;;

      # Ejecuta eliminación del script en el sistema en "/opt/sys-backup"
      uninstall)
        UNINSTALL_SYS-BACKUP_LOCAL
        ;;
    
      # Añade un directorio($4) para las copias de seguridad con una descripción($3)
      add-dir)
        ADD_DIR_LOCAL $3 $4
        ;;
    
      # Crea backup
      backup)
    
        case $3 in
    
          full)
            BACKUP-FULL_LOCAL
            ;;
    
          inc)
            BACKUP-INC_LOCAL
            ;;
        esac
        ;;
    
    esac

    ;;
  remote)
   case $2 in
      # Ejecuta instalación del script en el sistema en host $3(IP o FQDN) en el directorio "/opt/sys-backup"
      install)
        INSTALL_SYS-BACKUP_REMOTE $3
        ;;
    
      # Añade un directorio($4) para las copias de seguridad con una descripción($3)
      add-dir)
        ADD_DIR_REMOTE $3 $4
        ;;
    
      # Crea backup
      backup)
    
        case $3 in
    
          full)
            BACKUP-FULL_REMOTE
            ;;
    
          inc)
            BACKUP-INC_REMOTE
            ;;
        esac
        ;;
    
    esac

    ;;
esac