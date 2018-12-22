#!/bin/bash
#Nombre del archivo: sys-backup.bash
#Fecha de creación: 15/12/18
#Autor: Juan Pedro Carmona Romero
#Descripción: Script principal para sistema de backups

# Cargamos funciones
. /opt/sys-backup/functions.bash

# Comprobamos si somos ROOT
COMPROBAR_ROOT


case $1 in

  # Ejecuta instalación del script en el sistema en "/opt/sys-backup"
  install)
    INSTALL_SYS-BACKUP
    ;;

  # Ejecuta eliminación del script en el sistema en "/opt/sys-backup"
  uninstall)
    UNINSTALL_SYS-BACKUP
    ;;

  # Para ejecutar en local
  local)
    case $2 in

      # Crea directorio y ficheros necesarios en local
      install)
        INSTALL_SYS-BACKUP_LOCAL
        ;;

      # Añade un directorio($3) para las copias de seguridad locales
      add-dir)
        ADD_DIR_LOCAL $3
        ;;

      # Excluye un directorio($3) para las copias de seguridad locales
      exc-dir)
        ADD_EXC-DIR_LOCAL $3
        ;;

      # Executa backup para cron
      cron-backup)
        CRON_BACKUP_LOCAL
        ;;

      # Añade crontab para realizar las copias automáticas locales
      add-cron)
        ADD-CRON_LOCAL
        ;;

      # Elimina cron local de backups
      add-cron)
        DEL-CRON_LOCAL
        ;;

      # Restauración local completa o parcial dada una fecha "$3" y alternativamente un fichero o directorio "$4"
      restore)
        RESTORE_LOCAL $3 $4
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

      # Crea directorio y ficheros necesarios en local para backups remotos
      install)
        INSTALL_SYS-BACKUP_REMOTE $2
        ;;

      # Añade un directorio($4) para las copias de seguridad en el HOST($2)
      add-dir)
        ADD_DIR_REMOTE $2 $4
        ;;

      # Excluye un directorio($4) para las copias de seguridad en el HOST($2)
      exc-dir)
        ADD_EXC-DIR_REMOTE $2 $4
        ;;

      # Executa backup para cron
      cron-backup)
        CRON_BACKUP_REMOTE $2
        ;;

      # Añade crontab para realizar las copias automáticas locales
      add-cron)
        ADD-CRON_REMOTE $2
        ;;

      # Elimina cron local de backups
      add-cron)
        DEL-CRON_REMOTE $2
        ;;

      # Restauración remota completa o parcial dada una fecha "$4" y alternativamente un fichero o directorio "$5"
      restore)
        RESTORE_REMOTE $2 $4 $5
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