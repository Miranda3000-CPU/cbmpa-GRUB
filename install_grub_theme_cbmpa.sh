#!/usr/bin/env bash
set -euo pipefail

# Instala tema GRUB (Ubuntu/Debian)
# Uso: sudo ./install_grub_theme_cbmpa.sh
# O script copia themes/CBMPA -> /boot/grub/themes/CBMPA
# e ajusta /etc/default/grub para usar theme.txt

THEME_SRC_DIR="$(pwd)/themes/CBMPA"
THEME_NAME="CBMPA"
TARGET_DIR="/boot/grub/themes/${THEME_NAME}"
GRUB_DEFAULT_FILE="/etc/default/grub"
BACKUP="${GRUB_DEFAULT_FILE}.backup.$(date +%s)"

# checagens básicas
if [ ! -d "${THEME_SRC_DIR}" ]; then
  echo "Erro: diretório de tema não encontrado: ${THEME_SRC_DIR}" >&2
  exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "Execute com sudo: sudo $0" >&2
  exit 1
fi

# criar diretório alvo
mkdir -p "${TARGET_DIR}"

# copiar arquivos do tema
cp -a "${THEME_SRC_DIR}/." "${TARGET_DIR}/"

# ajustar permissões
chown -R root:root "${TARGET_DIR}"
chmod -R 755 "${TARGET_DIR}"

# fazer backup do /etc/default/grub
cp "${GRUB_DEFAULT_FILE}" "${BACKUP}"
echo "Backup de ${GRUB_DEFAULT_FILE} -> ${BACKUP}"

# definir GRUB_THEME
GRUB_THEME_LINE="GRUB_THEME=\"${TARGET_DIR}/theme.txt\""

if grep -q '^GRUB_THEME=' "${GRUB_DEFAULT_FILE}"; then
  sed -i "s|^GRUB_THEME=.*|${GRUB_THEME_LINE}|" "${GRUB_DEFAULT_FILE}"
else
  echo "${GRUB_THEME_LINE}" >> "${GRUB_DEFAULT_FILE}"
fi

# se houver GRUB_BACKGROUND retire ou comente para evitar conflito (opcional)
if grep -q '^GRUB_BACKGROUND=' "${GRUB_DEFAULT_FILE}"; then
  sed -i "s|^GRUB_BACKGROUND=|#GRUB_BACKGROUND=|g" "${GRUB_DEFAULT_FILE}"
fi

# atualizar grub
if command -v update-grub >/dev/null 2>&1; then
  update-grub
elif command -v grub-mkconfig >/dev/null 2>&1; then
  grub-mkconfig -o /boot/grub/grub.cfg
else
  echo "Aviso: não foi encontrado update-grub nem grub-mkconfig. Atualize o grub manualmente." >&2
  exit 1
fi

echo "Tema instalado em ${TARGET_DIR}"
echo "GRUB configurado para usar ${TARGET_DIR}/theme.txt"
echo "Reinicie para ver o novo tema."
