{ config, pkgs, ... }:

{
    home.username = "pabloqpacin";
    home.homeDirectory = "/home/pabloqpacin";
}

# https://stackoverflow.com/questions/38576616/how-to-install-gtk-themes-under-nixos-without-hacky-scripts
# {
#   gtk = {
#     enable = true;
#     theme = {
#       name = "Materia-dark";
#       package = pkgs.materia-theme;
#     };
#   };
# }
