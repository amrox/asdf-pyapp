<div align="center">

# asdf-pyapp ![Build](https://github.com/amrox/asdf-pyapp/workflows/Build/badge.svg) ![Lint](https://github.com/amrox/asdf-pyapp/workflows/Lint/badge.svg)

[pyapp](https://github.com/amrox/pyapp) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

Plugin to install arbitrary Python Applications in isolated environments.

## WARNING: The README is WIP

# Contents

- [Contents](#contents)
- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `python`/`python3` >= 3.6 with pip and venv
- OR (coming soon) [asdf-python](https://github.com/danhper/asdf-python) installed

# Install

Plugin:

```shell
asdf plugin add <python app> https://github.com/amrox/asdf-pyapp.git
# for example
asdf plugin add cowsay https://github.com/amrox/asdf-pyapp.git
```

Example using `cowsay`:

```shell
# Show all installable versions
asdf list-all cowsay

# Install specific version
asdf install cowsay latest

# Set a version globally (on your ~/.tool-versions file)
asdf global cowsay latest

# Now cowsay commands are available
cowsay "Hi!"
```

Some compatible apps:


| App                                               | Command to add Plugin                                                  | Notes                                                                                  |
| ------------------------------------------------- | ---------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| [ansible](https://pypi.org/project/ansible-base/) | `asdf plugin add ansible-base https://github.com/amrox/asdf-pyapp.git` | Note app name is `ansible-base`                                                        |
| [awscli](https://pypi.org/project/awscli/)        | `asdf plugin add awscli https://github.com/amrox/asdf-pyapp.git`       |                                                                                        |
| [black](https://pypi.org/project/black/)          | `asdf plugin add black https://github.com/amrox/asdf-pyapp.git`        | [`black latest` does not work currently](https://github.com/amrox/asdf-pyapp/issues/2) |
| [conan](https://pypi.org/project/conan/)          | `asdf plugin add conan https://github.com/amrox/asdf-pyapp.git`        |                                                                                        |
| [cowsay](https://pypi.org/project/cowsay/)        | `asdf plugin add cowsay https://github.com/amrox/asdf-pyapp.git`       |                                                                                        |
| [doit](https://pypi.org/project/doit/)            | `asdf plugin add doit https://github.com/amrox/asdf-pyapp.git`         |                                                                                        |
| [flake8](https://pypi.org/project/flake8/)        | `asdf plugin add flake8 https://github.com/amrox/asdf-pyapp.git`       |                                                                                        |
| [hy](https://pypi.org/project/hy/)                | `asdf plugin add hy https://github.com/amrox/asdf-pyapp.git`           |                                                                                        |
| [mymy](https://pypi.org/project/mymy/)            | `asdf plugin add mypy https://github.com/amrox/asdf-pyapp.git`         |                                                                                        |
| [pipenv](https://pypi.org/project/pipenv/)        | `asdf plugin add pipenv https://github.com/amrox/asdf-pyapp.git`       |                                                                                        |


Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to install & manage versions.

# Configuration

## Environment Variables

- `ASDF_PYAPP_DEFAULT_PYTHON_PATH` - Path to a `python`/`python3`  binary this plugin should use. Default is unset. See Python Resolution section for more details.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/amrox/asdf-pyapp/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Andy Mroczkowski](https://github.com/amrox/)
