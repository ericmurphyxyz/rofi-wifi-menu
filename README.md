# rofi-wifi-menu

A Wi-Fi menu written in bash. Uses rofi and nmcli. Forked from [zbaylin](https://github.com/zbaylin/rofi-wifi-menu) because it was unmaintained and incompatible with modern versions of rofi. Additional contributions from [vlfldr](https://github.com/vlfldr/rofi-wifi-menu)'s fork.

![Screenshot of rofi-wifi-menu](https://user-images.githubusercontent.com/19492564/147341323-3c5cfd08-1f66-4555-b21f-038f063bcf44.png)

### Installation

Install `nmcli` and `rofi` with your package manager. If you want to use the icons, set your Rofi font to a [Nerd Font](https://github.com/ryanoasis/nerd-fonts). Then run the following commands:

```
git clone https://github.com/ericmurphyxyz/rofi-wifi-menu.git
cd rofi-wifi-menu
bash "./rofi-wifi-menu.sh"
```

You'll probably want to put the script in your `$PATH` so you can run it as a command and map a keybinding to it.

### Troubleshooting

PopOS! does not have the notify-send library installed by default. You can install it with the following command (according to this [thread](https://unix.stackexchange.com/questions/685247/what-is-the-notify-send-alternative-command-in-pop-os)):
  
  ```bash
  sudo apt install libnotify-bin
  ```
