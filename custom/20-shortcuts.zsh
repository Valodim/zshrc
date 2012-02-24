# creates a new subdirectory, and moves all files or dirs that start with the
# same name into it, stripping that same part off.
#
# trailing spaces in the argument name will also be stripped
function mksub () {
    setopt localoptions extendedglob
    d=${1% #}
    mkdir $d
    a=( $~1*~$d(N) )
    for i in $a; do
        mv $i $d/${i#$1}
    done
}
