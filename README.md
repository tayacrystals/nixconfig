# nixconfig

taya's NixOS flake configuration.

## Structure

```
.
├── flake.nix                        # Inputs and nixosConfigurations
├── hosts/
│   ├── workstation/
│   │   ├── default.nix              # Host system config
│   │   ├── home.nix                 # Host home-manager config
│   │   └── hardware-configuration.nix
│   └── laptop/
│       ├── default.nix
│       ├── home.nix
│       └── hardware-configuration.nix
└── modules/
    ├── nixos/
    │   ├── common.nix               # Shared system settings (nix, locale, audio, fonts)
    │   ├── users.nix                # User accounts
    │   └── desktop/
    │       └── hyprland.nix         # Hyprland + display manager + wayland deps
    └── home/
        ├── common.nix               # Shared home config (zsh, git, kitty, packages)
        └── desktop/
            └── hyprland.nix        # Hyprland, waybar, hyprlock, GTK theming
```

## First-time setup

### 1. Generate hardware config

On each machine, run:

```bash
nixos-generate-config --show-hardware-config
```

Copy the output into the respective `hosts/<hostname>/hardware-configuration.nix`.

### 2. Clone the repo to `/etc/nixos`

```bash
sudo mv /etc/nixos /etc/nixos.bak
sudo git clone <repo-url> /etc/nixos
```

Or keep it in `~/nixconfig` and reference it with a full path.

### 3. Customize

- **Timezone**: edit `modules/nixos/common.nix` → `time.timeZone`
- **Git email**: edit `modules/home/common.nix` → `programs.git.userEmail`
- **Monitors**: uncomment the `monitor` lines in `hosts/<hostname>/home.nix`
- **GPU drivers**: uncomment in `hosts/workstation/default.nix`

### 4. Apply

```bash
# Switch immediately
sudo nixos-rebuild switch --flake /etc/nixos#workstation

# Or use the shell alias after first build:
nrs   # expands to nixos-rebuild switch --flake ... #$(hostname)
```

## Updating inputs

```bash
nix flake update
```

## Hosts

| Hostname     | Role       | Notes                        |
|--------------|------------|------------------------------|
| workstation  | Desktop    | No power management          |
| laptop       | Laptop     | TLP, bluetooth, lid suspend  |
