#!/bin/bash
# =============================================================================
# @file    yaml.sh
# @brief   Parse a YAML file
# @author  Jonathan Peres (https://github.com/jasperes)
# @license MIT License
# @website https://github.com/jasperes/bash-yaml
#
# IMPORTANT: this has been modified from the original version.  The most
# important change is that this replaces space characters in the values of
# variable assignments with the string "~~~", in order to make it possible to
# read assignments in the Makefile that calls this code.  Other changes: the
# value assignment omits the parentheses that the original version added,
# omits double quotes around values, fixes a bug in a sed expression, and
# removes code that translated dashes to underscores in variable names.
#
# The contents of this file originally came from "yaml.sh" in the "bash-yaml"
# repository at https://github.com/jasperes/bash-yaml/ as it existed
# on 2018-02-14. The git commit hash at the time was 57df439 (Nov 29, 2017).
# =============================================================================

function parse_yaml() {
    local yaml_file=$1
    local prefix=$2
    local s
    local w
    local fs

    s='[[:space:]]*'
    w='[a-zA-Z0-9_.-]*'
    fs="$(echo @|tr @ '\034')"

    (
        sed -ne '/^--/s|--||g; s|\"|\\\"|g; s/$s*$//g;' \
            -e "/#.*[\"\']/!s| #.*||g; /^#/s|#.*||g;" \
            -e "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
            -e "s|^\($s\)\($w\)$s[:-]$s\(.*\)$s\$|\1$fs\2$fs\3|p" |

        # If the value on the RHS contains spaces, then the $(shell)
        # invocation in calling makefile breaks strings into multiple lines
        # at space characters.  I could not find another solution except to
        # replace spaces in the value with a character sequence that is then
        # filtered out in the makefile after the $(foreach) is used.  This
        # is the reason for the following replacement:

        sed -e 's/ /~~~/g' |

        awk -F"$fs" '{
            indent = length($1)/2;
            if (length($2) == 0) { conj[indent]="+";} else {conj[indent]="";}
            vname[indent] = $2;
            for (i in vname) {if (i > indent) {delete vname[i]}}
                if (length($3) > 0) {
                    vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
                    printf("%s%s%s%s=%s\n", "'"$prefix"'",vn, $2, conj[indent-1],$3);
                }
            }' |

        sed -e 's/_=/+=/g' \
            -e 's/_+=/+=/g' \
            -e '/\..*=/s|\.|_|'

    ) < "$yaml_file"
}

function create_variables() {
    local yaml_file="$1"
    eval "$(parse_yaml "$yaml_file")"
}
