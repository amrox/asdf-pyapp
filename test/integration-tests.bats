ASDF_PYTHON_VERSION=3.8.8


in_container () {
  args=($*)
  docker exec -it "$CONTAINER" bash -l -c "${args[*]@Q}"
}

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'

  MY_DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  SRCROOT=$(dirname "$MY_DIR")

  TAG="asdf-pyapp-integration-bionic"
  CONTAINER="${TAG}-container"

  docker build \
    -f docker/bionic/Dockerfile \
    -t "$TAG" \
    --build-arg ASDF_PYTHON_VERSION="$ASDF_PYTHON_VERSION" \
    "$SRCROOT"
  docker run --rm -d -it --init --name "$CONTAINER" "$TAG"
  in_container mkdir /root/.asdf/plugins || true
}

teardown() {
  docker stop "$CONTAINER"
}

@test "can install with system python no asdf" {

  # asdf python is baked into the container, remove it first
  in_container asdf plugin remove python

  run in_container which python3
  assert_output --partial /usr/bin/python3  #TODO: why is --partial required? newline?

  in_container cp -r /root/asdf-pyapp /root/.asdf/plugins/cowsay
  in_container asdf install cowsay 4.0
  in_container asdf global cowsay 4.0
  in_container cowsay "woo woo"
}

@test "can install with system python via asdf" {

  in_container asdf global python system

  run in_container which python3
  assert_output --partial /root/.asdf/shims/python3

  in_container cp -r /root/asdf-pyapp /root/.asdf/plugins/cowsay
  in_container asdf install cowsay 4.0
  in_container asdf global cowsay 4.0
  in_container cowsay "woo woo"
}

@test "can install with asdf python $ASDF_PYTHON_VERSION" {

  in_container asdf global python "$ASDF_PYTHON_VERSION"

  run in_container which python3
  assert_output --partial /root/.asdf/shims/python3

  in_container cp -r /root/asdf-pyapp /root/.asdf/plugins/cowsay
  in_container asdf install cowsay 4.0
  in_container asdf global cowsay 4.0
  in_container cowsay "woo woo"
}

@test "check \$ASDF_PYAPP_DEFAULT_PYTHON_PATH works" {

  in_container asdf global python "$ASDF_PYTHON_VERSION"

  run in_container which python3
  assert_output --partial /root/.asdf/shims/python3

  in_container cp -r /root/asdf-pyapp /root/.asdf/plugins/cowsay
  in_container "echo \"ASDF_PYAPP_DEFAULT_PYTHON_PATH=/usr/bin/python3\" >> /root/.profile"
  in_container asdf install cowsay 4.0

  run in_container readlink /root/.asdf/installs/cowsay/4.0/pipx-venv/bin/python3
  assert_output --partial /usr/bin/python3
}

@test "tmp 1" {

  in_container asdf global python "$ASDF_PYTHON_VERSION"

  run in_container which python3
  assert_output --partial /root/.asdf/shims/python3

  in_container cp -r /root/asdf-pyapp /root/.asdf/plugins/cowsay
  in_container asdf install cowsay 4.0
  in_container asdf global cowsay 4.0
  in_container cowsay "woo woo"
}

##################################################
# Individual App Checks

check_app() {
  local app="$1"
  local version="$2"
  shift; shift

  in_container cp -r /root/asdf-pyapp /root/.asdf/plugins/"$app"
  in_container asdf install "$app" "$version"
  in_container asdf global "$app" "$version"

  in_container $*
}

@test "check app ansible latest" {
  check_app ansible-base latest ansible --version
}

@test "check app awscli latest" {
  check_app awscli latest aws --version
}

@test "check app black latest" {
  skip
  # TODO: black latest doesn't work for some reason
  check_app black latest black --version
}

@test "check app black 21.5b2" {
  check_app black 21.5b2 black --version
}

@test "check app conan latest" {
  check_app conan latest conan --version
}

@test "check app doit latest" {
  check_app doit latest doit --version
}

@test "check app flake8 latest" {
  check_app flake8 latest flake8 --version
}

@test "check app hy latest" {
  check_app hy latest hy --version
}

@test "check app mypy latest" {
  check_app mypy latest mypy --version
}

@test "check app pipenv latest" {
  check_app pipenv latest pipenv --version
}
