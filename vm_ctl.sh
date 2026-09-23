vm_list() {
    echo "Memindai daftar Virtual Machine..."
    echo "Daftar VM terdaftar:"
    VBoxManage list vms | awk -F'"' '{print NR". "$2}'
}
snapshot(){
    if [ "$2" == "create" ]; then
        VBoxManage snapshot $3 take $4
    elif [ "$2" == "list" ]; then
        VBoxManage snapshot $3 list
    fi
}
echo "===================================
     TUGAS 1 OS - KELOMPOK B7      
==================================="
if [ "$1" == "list" ]; then
    list $1
elif [ "$1" == "info" ]; then
    info $1 $2
elif [ "$1" == "start" ]; then
    start $1 $2 
elif [ "$1" == "stop" ]; then
    stop $1 $2
elif [ "$1" == "snapshot" ]; then
    snapshot $1 $2 $3 $4
fi
