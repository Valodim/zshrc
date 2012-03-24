# creates a new subdirectory, and moves all files or dirs that start with the
# same name into it, stripping that same part off.
#
# trailing spaces in the argument name will also be stripped
function mksub () {
    setopt localoptions extendedglob
    # strip whitespace from the dir
    d=${1% #}
    # create the sub dir, if it doesn't exist
    [[ ! -e $d ]] && mkdir $d
    # glob all extensions, but not $d itself
    a=( $~1*~$d(N) )
    # move all of those one level down
    for i in $a; do
        # strip the sub dir name in the process
        mv $i $d/${${i#$1}# #}
    done
}
