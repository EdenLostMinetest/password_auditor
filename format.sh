#!/bin/bash

MDFORMAT="${HOME}/.local/bin/mdformat"
LUAFORMAT="${HOME}/.luarocks/bin/lua-format"

[[ -x "${MDFORMAT}" ]] && "${MDFORMAT}" --wrap=80 *.md

[[ -x "${LUAFORMAT}" ]] && "${LUAFORMAT}" --in-place --column-limit=80 --indent-width=4 --no-use-tab --align-args --align-parameter *.lua

