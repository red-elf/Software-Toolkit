#!/bin/bash

CHECK_PREFIXES () {
    value=$1
    shift

    for prefix do
        case $value in
            "$prefix"*) return 0
        esac
    done

    return 1
}

CHECK_CONTAINS () {
    value=$1
    shift

    case $value in
        *"$1"*) return 0
    esac

    return 1
}
