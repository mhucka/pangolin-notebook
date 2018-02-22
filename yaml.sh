#!/bin/bash
# =============================================================================
# @file    yaml.sh
# @brief   Parse a YAML file
# @author  Jonathan Peres (https://github.com/jasperes)
# @license MIT License
# @website https://github.com/jasperes/bash-yaml
#
# IMPORTANT: this has been modified from the original version.  I changed the
# value assignment to omit the parentheses that the original version added,
# omit double quotes around values, fix a bug in a sed expression, and
# remove code that translated dashes to underscores in variable names.
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
            -e '/\..*=/s|\.|_|'

    ) < "$yaml_file"
}

function create_variables() {
    local yaml_file="$1"
    eval "$(parse_yaml "$yaml_file")"
}
