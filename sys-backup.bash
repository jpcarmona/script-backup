#!/bin/bash
#Nombre del archivo: sys-backup.bash
#Fecha de creación: 15/12/18
#Autor: Juan Pedro Carmona Romero
#Descripción: Script principal para sistema de backups

# Cargamos funciones
. functions.bash

# Comprobamos si somos ROOT
COMPROBAR_ROOT

echo -e "\e[1;42m Bienvenido al comprobador de intentos de acceso fallidos por SSH \e[0m "
echo -e "\e[1;42m ---------------------------- JUANPEBIN ------------------------- \e[0m "


case $1 in
  local)
    case $2 in
      # Ejecuta instalación del script en el sistema en el directorio $2
      install)
        INSTALL_SYS-BACKUP_LOCAL
        ;;
    
      # Añade un directorio($4) para las copias de seguridad con una descripción($3)
      add-dir)
        ADD_DIR_LOCAL $3 $4
        ;;
    
      # Crea backup
      backup)
    
        case $2 in
    
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
      # Ejecuta instalación del script en el sistema en el directorio $2
      install)
        INSTALL_SYS-BACKUP_REMOTE
        ;;
    
      # Añade un directorio($4) para las copias de seguridad con una descripción($3)
      add-dir)
        ADD_DIR_REMOTE $3 $4
        ;;
    
      # Crea backup
      backup)
    
        case $2 in
    
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