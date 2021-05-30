# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

#
asdf plugin test cowsay https://github.com/amrox/asdf-pyapp.git "cowsay Hi"
```

Tests are automatically run in GitHub Actions on push and PR.
