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
  # Ejecuta instalación del script en el sistema en el directorio $2
  install)
  INSTALL_SYS-BACKUP $2
  ;;
# Añade un directorio para las copias de seguridad
  add-dir)
  ADD_DIR $2 $3
  ;;
  2)
  JUANPEBIN_INSTALAR
  ;;
  3)
  JUANPEBIN_CONFIGURAR
  ;;
  4)
  JUANPEBIN_DESINTALAR
  ;;
esac