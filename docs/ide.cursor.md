# [Cursor](https://www.cursor.com/)

- Sign Up:
- 
- 
```yaml
Cursor.com:
  Sign Up:
    First name: Pablo
    Last name: Quevedo
    Email: pquevedo@setenova.es

```
-  email `pquevedo@setenova.es`...
- Download for Linux: `~/Downloads/cursor-0.44.11x86_64.AppImage`
- Ejecutar:

```bash
# https://www.youtube.com/watch?v=EX-0ui_hQMo

mv ~/Downloads/cursor-*.AppImage /opt/cursor.appimage
sudo chmod +x /opt/cursor.appimage

wget https://us1.discourse-cdn.com/flex020/uploads/cursor1/original/2X/a/a4f78589d63edd61a2843306f8e11bad9590f0ca.png
sudo mv a*.png /opt/cursor.png

sudo tee /usr/share/applications/cursor.desktop << EOF
[Desktop Entry]
Name=Cursor
Exec=/opt/cursor.appimage
Icon=/opt/cursor.png
Type=Application
Categories=Development;
EOF
```
- Ejecutar en la terminal
```sh
sudo ln -s /opt/cursor.appimage /usr/local/bin/cursor
```

- Launcher: **Cursor**

```yaml
Cursor:
  Init:
    Keyboard: Default (VS Code) # Vim
    Language for AI: Spanish
    Codebase-wide: true
    # Add Terminal Command: -
    Import VS Code Extensions: false
    Data Preferences: Telemetry #! Privacy Mode
    # Log In: ...
  Open a folder:
    - ~/repos/Setenova/PR-Cetursa_XXII_Analitica
```

---

- Extensiones...

```yaml
Extensions:
  - zhuangtongfa.material-theme
  - vscode-icons-team.vscode-icons
  # - redhat.vscode-yaml
  # ...
```

