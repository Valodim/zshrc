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

# this is a curl wrapper for http://offliberty.com
function offliberty() {
    # stuff this is known to work with:
    #  * mixcloud

    # Usage
    [[ $# != 1 ]] && echo "Usage: $0 URL" >&2 && return 1

    # Retrieve data (thanks offliberty guys for making this as simple as it is :) )
    data=$(curl --silent --data-urlencode track=$1 http://offliberty.com/off.php | grep 'download')
    ret=$?

    # Got an error :(
    if (( $ret != 0 )); then
        echo 'Error with curl!'
        return $ret
    fi

    # Match the url
    if [[ $data =~ '.*"(http://[a-zA-Z0-9_/.-]*)" .*' ]]; then
        echo $match
    else
        echo 'No url found in answer!' >&2
        return 2
    fi

    # todo: offliberty sometimes returns mp3, sometimes m4a.. maybe add an option to force one filetype

}
