#!/usr/bin/env bash

set -u

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
CODE_DIR="${WORKSPACE}/code"
TESTS_DIR="${WORKSPACE}/tests"
PASSES=0
FAILURES=0

pass() {
    printf 'PASS: %s\n' "$1"
    PASSES=$((PASSES + 1))
}

fail() {
    printf 'FAIL: %s\n' "$1"
    FAILURES=$((FAILURES + 1))
}

check() {
    local description="$1"
    shift

    if "$@"; then
        pass "${description}"
    else
        fail "${description}"
    fi
}

content_equals() {
    local path="$1"
    local expected="$2"

    [[ -f "${path}" ]] || return 1
    [[ "$(cat -- "${path}")" == "${expected}" ]]
}

compiles_cleanly() {
    local description=""

    gcc -Wall -Wextra -Werror -std=c11 -fsyntax-only "${CODE_DIR}/carga.c" >/dev/null 2>&1 || return 1
    [[ -f "${CODE_DIR}/carga" && -x "${CODE_DIR}/carga" ]] || return 1
    description="$(file -b -- "${CODE_DIR}/carga")"
    [[ "${description}" == ELF*executable* ]]
}

boundary_is_correct() {
    local output=""

    output="$("${CODE_DIR}/carga" 2>/dev/null <<< '500')" || return 1
    [[ "${output}" == 'Carga: pesada' ]]
}

test004_is_correct() {
    content_equals "${TESTS_DIR}/test004.in" '100' || return 1
    content_equals "${TESTS_DIR}/test004.expected" 'Carga: media' || return 1
    [[ -x "${SCRIPT_DIR}/tests-run.sh" ]] || return 1
    "${SCRIPT_DIR}/tests-run.sh" "${CODE_DIR}/carga" "${TESTS_DIR}" >/dev/null 2>&1
}

printf '%s\n' '========================================='
printf '%s\n' '==   Verificación de laboratorio PR1   =='
printf '%s\n' '========================================='
printf '\n== Actividades ==========================\n\n'

check "[1/4] El programa compila sin warnings y corresponde a un binario" compiles_cleanly
check "[2/4] La condición de borde entrega el resultado correcto" boundary_is_correct
check \
    "[3/4] test003.expected contiene el resultado correcto" \
    content_equals "${TESTS_DIR}/test003.expected" 'Carga: pesada'
check "[4/4] El test case solicitado existe y la suite finaliza correctamente" test004_is_correct

printf '\n== Resumen ===============================\n\n'
TOTAL=$((PASSES + FAILURES))
COUNT_WIDTH=${#TOTAL}
printf '%-25s %*d\n' 'Actividades completadas:' "${COUNT_WIDTH}" "${PASSES}"
printf '%-25s %*d\n\n' 'Actividades pendientes:' "${COUNT_WIDTH}" "${FAILURES}"

if (( FAILURES == 0 )); then
    exit 0
fi

exit 1
