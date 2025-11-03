## unreleased

## 0.7 - 2025-11-03

- fix environment variables for `config_dir` and `data_dir` (thanks @rossberg)

## 0.6 - 2025-01-28

- use `Fpath.t` instead of `string` where possible

## 0.5 - 2022-01-09

- add Base_dirs.state_dir, on linux it uses $XDG_STATE_HOME and default to $HOME/.local/.state on macOS and Windows it's equivalent to Base_dirs.cache_dir ; add Projects_dirs.state_dir

## 0.4 - 2021-11-25

- rename module Common to Directories_common

## 0.3 - 2021-03-31

- use ctypes.stubs instead of ctypes.foreign on windows
- clean the windows implementation

## 0.2 - 2020-11-09

- fix opam file

## 0.1 - 2020-11-08

First release
