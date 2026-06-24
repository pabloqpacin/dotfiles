Para **tu caso actual de módulo automatizado**, `~/.local` suele ser mejor opción que `/opt`.

- **`~/.local` (usuario)**: no requiere `sudo`, evita mezclar permisos root/usuario, es más portable entre distros y encaja muy bien con dotfiles/scripts personales.
- **`/opt` (sistema)**: mejor cuando quieres instalación **global** para varios usuarios o una política “admin-managed” más rígida.
- Para launcher, la pareja natural es:
  - usuario: `~/.local/share/applications/*.desktop`
  - sistema: `/usr/share/applications/*.desktop`
- Lo que hacías en `/opt` está perfecto como práctica “manual sysadmin”, pero para scripts idempotentes de bootstrap personal, `~/.local/bin` + `~/.local/share/applications` es más limpio y menos fricción.

Viendo tus docs (`docs/ide.cursor.md`, `docs/linux/Pop!_OS.md`), ahí tienes el enfoque clásico global; el script nuevo va más en línea “dotfiles per-user”.

Si quieres, lo dejo **híbrido** con variable:
- `MARKTEXT_INSTALL_SCOPE=user` (default actual)
- `MARKTEXT_INSTALL_SCOPE=system` (usa `/opt`, `/usr/local/bin`, `/usr/share/applications`)
