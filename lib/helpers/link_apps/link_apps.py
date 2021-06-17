import argparse
import os

from pathlib import Path

from pipx.venv import Venv


def link_apps(
    venv_path: Path, package_name: str, dest_dir: Path, force: bool = False
) -> None:
    venv = Venv(venv_path)
    apps = venv.get_venv_metadata_for_package(package_name, set()).apps

    os.makedirs(dest_dir, exist_ok=True)

    for app in apps:
        app_path = venv.bin_path / app
        dest_path = dest_dir / app
        if force and os.path.exists(dest_path):
            os.remove(dest_path)
        os.symlink(app_path, dest_path)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("venv_path", type=str, help="path to virtual environment")
    parser.add_argument("package_name", type=str, help="name of package")
    parser.add_argument("dest_dir", type=str, help="destintation dir for symlinks")
    parser.add_argument(
        "--force",
        action="store_true",
        default=False,
        help="removes dest symlink paths if they exist",
    )

    args = parser.parse_args()

    link_apps(
        Path(args.venv_path), args.package_name, Path(args.dest_dir), force=args.force
    )


if __name__ == "__main__":
    main()
