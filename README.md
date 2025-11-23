Theme for the Pará Military Fire Brigade. Includes an automated installation script using `bash` for Ubuntu/Debian. Perfect for use with Ventoy or GRUB customization.

PT-BR:

```bash
# Instala tema GRUB (Ubuntu/Debian)
# Uso: sudo ./install_grub_theme_cbmpa.sh
# O script copia themes/CBMPA -> /boot/grub/themes/CBMPA
# e ajusta /etc/default/grub para usar theme.txt
```

# Instalação:

## 1
```shell
git clone https://github.com/Jeiel0rbit/cbmpa.git && cd cbmpa && chmod +x install_grub_theme_cbmpa.sh && clear && ls`
```
## 2
```
sudo ./install_grub_theme_cbmpa.sh && echo -e "\e[31mReboot\e[0m"
```