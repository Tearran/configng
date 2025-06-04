<p align="center">
  <a href="#build-framework">
  <img src="https://raw.githubusercontent.com/armbian/configng/main/share/icons/hicolor/scalable/configng-tux.svg" width="128" alt="Armbian Config NG Logo" />
  </a><br>
  <strong>Armbian Config: The Next Generation</strong><br>
<br>
<a href=https://github.com/armbian/configng/actions/workflows/debian.yml><img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/armbian/configng/debian.yml?logo=githubactions&label=Packaging&style=for-the-badge&branch=main"></a> <a href=https://github.com/armbian/configng/actions/workflows/unit-tests.yml><img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/armbian/configng/unit-tests.yml?logo=githubactions&label=Unit%20tests&style=for-the-badge&branch=main"></a> <a href=https://github.com/armbian/configng/actions/workflows/docs.yml><img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/armbian/configng/docs.yml?logo=githubactions&label=Documentation&style=for-the-badge&branch=main"></a>
</p>

## What is armbian-config?

`armbian-config` is an interactive configuration utility for Armbian-based systems, designed to help users configure their device **after it has been installed and booted**. It provides a menu-driven interface for managing system settings, software, hardware, and services **within the running system ("image-space")**.


## Getting Started

Armbian Config comes preinstalled with Armbian. To get started, open a terminal or log in via SSH, then run:

```bash
armbian-config
```

<a href=#><img src=.github/images/common.png></a>

## Key Advantages
- **Lightweight**: Minimal dependencies for optimal performance.
- **Flexible**: Supports TUI, CLI, and automation interfaces.
- **Modern**: A fresh approach to configuration.
- **Low entropy**: Byte-clean uninstall for most targets.

## Compatibility

This tool is optimized for use with [**Armbian Linux**](https://www.armbian.com), but in theory, it should also work on any systemd-based, APT-compatible Linux distribution — including Linux Mint, Elementary OS, Kali Linux, MX Linux, Parrot OS, Proxmox, Raspberry Pi OS, and others.


<details><summary>Add Armbian key + repository and install the tool:</summary>
  
```bash
wget -qO - https://apt.armbian.com/armbian.key | gpg --dearmor | \
sudo tee /usr/share/keyrings/armbian.gpg > /dev/null
cat << EOF | sudo tee /etc/apt/sources.list.d/armbian-config.sources > /dev/null
Types: deb
URIs: https://github.armbian.com/configng
Suites: stable
Components: main
Signed-By: /usr/share/keyrings/armbian.gpg
EOF
sudo apt update
sudo apt -y install armbian-config
```

```bash
armbian-config
```
</details>


## Contributing

<a href="https://github.com/armbian/configng/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=armbian/configng" />
</a>
<br>
<br>
 
Thank you to everyone who has contributed to **Armbian-config** — your efforts are deeply appreciated!

#### General

- `armbian-config` operates **only in image-space**. It is **not** used during the image build process and does **not** affect image creation or customization at build time.
- If you wish to change the default contents, packages, or configurations included in an Armbian image before it is built, those changes must be made in the [Armbian build scripts](https://github.com/armbian/build), **not** in `armbian-config`.
- Feature requests or bug reports for `armbian-config` should be limited to things that can be changed or applied **within image-space** (i.e., on a running system), not during image creation or build time.

Contributions are welcome in many forms:

- 🐞 [Report bugs](https://github.com/armbian/configng/issues)
- 📚 [Improve documentation](https://docs.armbian.com/)
- 🛠️ [Fix or enhance code](https://github.com/armbian/configng/pulls)

Please read our [CONTRIBUTING.md](./CONTRIBUTING.md) before getting started.

#### Adding or configuring functionality

Want to expand Armbian-config with new features or tools? Whether you're adding a new software title, enhancing an existing configuration module, or introducing entirely new functionality, we welcome your ideas and code.

To get started:

- Review how similar features are implemented in the current codebase.
- Follow the structure and coding style used in existing modules.
- Ensure your additions are well-tested and don’t break existing functionality.
- Document any new options clearly so users understand how to use them.

<https://docs.armbian.com/Contribute/Armbian-config>

> 📌 Tip: Keep your changes modular and easy to maintain — this helps us review and merge your contribution faster.

#### 💖 Donating

Not a developer? You can still make a big impact! Your donations help us maintain infrastructure, test hardware, and improve development workflows.

[Support the project here](https://github.com/sponsors/armbian)

## License

(c) [Contributors](https://github.com/armbian/configng/graphs/contributors)

All code is licensed under the GPL, v3 or later. See [LICENSE](LICENSE) file for details.
