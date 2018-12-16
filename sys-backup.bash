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

  # Ejecuta instalación del script en el sistema en "/opt/sys-backup"
  install)
    INSTALL_SYS-BACKUP_LOCAL
    ;;

  # Ejecuta eliminación del script en el sistema en "/opt/sys-backup"
  uninstall)
    UNINSTALL_SYS-BACKUP_LOCAL
    ;;

  # Para ejecutar en local
  local)
    case $2 in

      # Añade un directorio($4) para las copias de seguridad con una descripción($3)
      add-dir)
        ADD_DIR_LOCAL $3 $4
        ;;

      # Excluye un directorio($4) para las copias de seguridad con una descripción($3)
      exc-dir)
        ADD_EXC-DIR_LOCAL $3 $4
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

          *)
            GET_AYUDA
            ;;

        esac
        ;;

      *)
        GET_AYUDA
        ;;

    esac

    ;;

  # Para ejecutar en remoto ($2 es el HOST)
  remote)

   case $3 in

      # Añade un directorio($5) para las copias de seguridad con una descripción($4) y el HOST($2)
      add-dir)
        ADD_DIR_REMOTE $2 $4 $5 
        ;;

      # Excluye un directorio($5) para las copias de seguridad con una descripción($4) y el HOST($2)
      exc-dir)
        ADD_EXC-DIR_REMOTE $2 $4 $5 
        ;;

      # Crea backup
      backup)

        case $4 in

          full)
            BACKUP-FULL_REMOTE $2
            ;;

          inc)
            BACKUP-INC_REMOTE $2
            ;;

          *)
            GET_AYUDA
            ;;

        esac
        ;;

      *)
        GET_AYUDA
        ;;

    esac

    ;;
  *)
    GET_AYUDA
    ;;
esac