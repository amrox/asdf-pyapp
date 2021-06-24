<div align="center">

# asdf-pyapp ![Build](https://github.com/amrox/asdf-pyapp/workflows/Build/badge.svg) ![Lint](https://github.com/amrox/asdf-pyapp/workflows/Lint/badge.svg)

A generic Python Application plugin the [asdf version manager](https://asdf-vm.com).

</div>

**What is a "Python Application"?**

For purposes of this plugin, a Python Application is program that *happens* to be written in Python, but otherwise behaves like a regular command-line tool.  The term "Python Application" comes from [pipx](https://pypa.github.io/pipx/).

Examples of Python Applications are [awscli](https://pypi.org/project/awscli/) and [conan](https://pypi.org/project/conan/). See below for more compatible applications.

# Dependencies

- `python`/`python3` >= 3.6 with pip and venv
- OR [asdf-python](https://github.com/danhper/asdf-python) installed

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

## Compatible Python Applications

This is a non-exhaustive list of Python Applications that work with this plugin.

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
| [meson](https://pypi.org/project/meson/)          | `asdf plugin add meson https://github.com/amrox/asdf-pyapp.git`        |                                                                                        |
| [mymy](https://pypi.org/project/mymy/)            | `asdf plugin add mypy https://github.com/amrox/asdf-pyapp.git`         |                                                                                        |
| [pipenv](https://pypi.org/project/pipenv/)        | `asdf plugin add pipenv https://github.com/amrox/asdf-pyapp.git`       |                                                                                        |
| [salt](https://pypi.org/project/salt/)            | `asdf plugin add salt https://github.com/amrox/asdf-pyapp.git`         |                                                                                        |
| [sphinx](https://pypi.org/project/Sphinx/)        | `asdf plugin add sphinx https://github.com/amrox/asdf-pyapp.git`       |                                                                                        |

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to install & manage versions.
.

# How it Works

asdf-pyapp is a lot more complex than most asdf plugins since it's designed to work with generic Python Applications, and challenges that come with Python itself.

asdf-pyapp uses the same technique as [asdf-hashicorp](https://github.com/asdf-community/asdf-hashicorp) to use a single plugin for multiple tools.

When installing a tool, asdf-pyapp creates a fresh [virtual environment](https://docs.python.org/3/tutorial/venv.html) and pip-installs the package matching the plugin name. Then it uses pipx under the hood to extract the entrypoints for the package exposes them to asdf.

## Python Resolution

To run Python Applications, you need Python:

1. If `ASDF_PYAPP_DEFAULT_PYTHON_PATH` is set - use it
1. Else if the `asdf-python` plugin is installed - use the **global** `python3`\*\*.
1. Finally, just use `python3` in our path.

\*\* *We use the global `python3` to avoid picking up local python versions inside projects, which would result in inconsistent tool installations. If you want to install a tool with a specific version of Python see the following section on asdf-python Integration.*

## asdf-python Integration (Experimental)

Here we color outside the lines a bit :)

asdf-python supports installing a Python App with a *specific* Python version using a special syntax. This feature requires the [asdf-python](https://github.com/danhper/asdf-python) plugin to be installed.

The general form is:

```shell
asdf <app> install <app-version>@<python-version>
```

For example, to install `cowsay` 3.0 with Python 3.9.1:

```shell
asdf cowsay install 3.0@3.9.1
```

Python Apps with different python versions and python itself can all happily co-exist in the same project. For example, take this `.tool-versions`:

```shell
python 3.8.5
awscli 1.19.93
cowsay 3.0@3.9.1
conan 1.36.0@3.8.5
```

- `awscli` will be installed with the global Python (see Python Resolution), in an isolated virtual environment
- Python 3.9.1 will be installed, and then `cowsay` will be installed using that Python (in a venv)
- `conan` will be installed with Python 3.8.5, but isolated from the project's Python, which is also 3.8.5.

# Configuration

## Environment Variables

- `ASDF_PYAPP_DEFAULT_PYTHON_PATH` - Path to a `python`/`python3`  binary this plugin should use. Default is unset. See Python Resolution section for more details.
- `ASDF_PYAPP_VENV_COPY_MODE`:
  - `0`: (default) Add `--copies` flag to venvs created with a specific Python version. Symlinks otherwise.
  - `1`: Prefer `--copies` whenever possible (`--copies` does not work with `/usr/bin/python3` on macOS).
- `ASDF_PYAPP_DEBUG` - Set to `1` for additional logging

# Background and Inspiration

asdf-pyapp was inspired by [asdf-hashicorp](https://github.com/asdf-community/asdf-hashicorp) and [pipx](https://pypa.github.io/pipx/) - which is also used under the hood. Big thanks to the creators, contributors, and maintainers of both these projects.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/amrox/asdf-pyapp/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Andy Mroczkowski](https://github.com/amrox/)
