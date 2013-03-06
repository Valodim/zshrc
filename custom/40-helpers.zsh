# usage: *(o+rand) or *(+rand)
function rand() {
    REPLY=$RANDOM; (( REPLY > 16383 ))
}
