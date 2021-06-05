ASDF_PYAPP_MY_NAME=asdf-pyapp

fail() {
  echo -e "${ASDF_PYAPP_MY_NAME}: [ERROR] $*"
  exit 1
}

log() {
  echo -e "${ASDF_PYAPP_MY_NAME}: $*"
}

get_python_version() {
  local python_path="$1"
  local regex='Python (.+)'

  python_version_raw=$("$python_path" --version)

  if [[ $python_version_raw =~ $regex ]]; then
    echo -n "${BASH_REMATCH[1]}"
  else
    fail "Unable to determine python version"
  fi
}

get_python_pip_versions() {
  local python_path="$1"

  local pip_version_raw; pip_version_raw=$("${python_path}" -m pip --version)
  local regex='pip (.+) from.*\(python (.+)\)'

  if [[ $pip_version_raw =~ $regex ]]; then
    echo -n "${BASH_REMATCH[1]}"
    #ASDF_PYAPP_PYTHON_VERSION="${BASH_REMATCH[2]}" # probably not longer needed
  else
    fail "Unable to determine pip version"
  fi
}

set_python_path() {
  # 1. if ASDF_PYAPP_DEFAULT_PYTHON_PATH is set, use it
  # 2. if not, test $(which python3). if >= 3.6 use it
  # 3. if not test /usr/bin/python3

  # TODO: throw error if a python version >= 3.6 can't be found?

  [ -v ASDF_PYAPP_DEFAULT_PYTHON_PATH ] && return

  # cd to $HOME to avoid picking up a local python from .tool-versions
  # pipx is best when install with a global python
  pushd "$HOME" > /dev/null || fail "Failed to pushd \$HOME"

  #local paths=("/usr/bin/python3" "$(which python3)")
  local paths=("$(which python3)" "/usr/bin/python3")

  for p in "${paths[@]}"; do
    local python_version
    python_version=$(get_python_version "$p")
    if [[ $python_version =~ ^([0-9]+)\.([0-9]+)\. ]]; then
      local python_version_major=${BASH_REMATCH[1]}
      local python_version_minor=${BASH_REMATCH[2]}
      if [ "$python_version_major" -ge 3 ] && [ "$python_version_minor" -ge 6 ]; then
        ASDF_PYAPP_DEFAULT_PYTHON_PATH="$p"
        break
      fi
    else
      continue
    fi
  done

  popd > /dev/null || fail "Failed to popd"
}

get_package_versions() {

  local package=$1

  local pip_version
  pip_version=$(get_python_pip_versions "$ASDF_PYAPP_DEFAULT_PYTHON_PATH")
  if [[ $pip_version =~ ^([0-9]+)\. ]]; then
    local pip_version_major=${BASH_REMATCH[1]}
  else
    fail "Unable to parse pip major version"
  fi

  local pip_install_args=""
  local version_output_raw
  if [ "${pip_version_major}" -gt 20 ]; then
    pip_install_args+=" --use-deprecated=legacy-resolver"
  fi
  version_output_raw=$("${ASDF_PYAPP_DEFAULT_PYTHON_PATH}" -m pip install ${pip_install_args} "${package}==" 2>&1) || true

  local regex='.*from versions:(.*)\)'
  if [[ $version_output_raw =~ $regex ]]; then
    local version_string="${BASH_REMATCH[1]//','/}"
    echo "$version_string"
  else
    fail "Unable to parse versions for '${package}'"
  fi
}

# TODO: check that we're doing sorting correctly (see bin/list-all)
#sort_versions() {
#  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
#    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
#}

install_version() {
  local package="$1"
  local install_type="$2"
  local full_version="$3"
  local install_path="$4"

  local versions=(${full_version//\@/ })
  local app_version=${versions[0]}
  if [ "${#versions[@]}" -gt 1 ]; then
    python_version=${versions[1]}
  fi

  if [ "${install_type}" != "version" ]; then
    fail "${ASDF_PYAPP_MY_NAME} supports release installs only"
  fi

  mkdir -p "${install_path}"

  # Install pipx
  local pipx_venv=${install_path}/pipx-venv
  pushd "$HOME" > /dev/null || fail "Failed to pushd \$HOME"
  #"${ASDF_PYAPP_DEFAULT_PYTHON_PATH}" -m venv --copies "${pipx_venv}"
  "${ASDF_PYAPP_DEFAULT_PYTHON_PATH}" -m venv "${pipx_venv}"
  "${pipx_venv}"/bin/pip install pipx
  popd > /dev/null || fail "Failed to popd"

  # install the app
  local python_arg=""
  if [ -v python_version ]; then
    # TODO: this needs to be reworked..
    python_arg="--python $python_version"
  fi

  export PIPX_HOME=${install_path}/pipx-home
  export PIPX_BIN_DIR=${install_path}/bin
  #pushd "$HOME" > /dev/null || fail "Failed to pushd \$HOME"
  "${pipx_venv}"/bin/pipx install $python_arg "$package"=="$app_version"
  #popd > /dev/null || fail "Failed to popd"

  echo ""
  log "Ignore warnings regarding \`pipx ensurepath\` - this is not necessary with asdf."
  log "$package $full_version successfully installed!"
  echo ""
}


set_python_path
