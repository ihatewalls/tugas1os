vm_list() {
    echo "Memindai daftar Virtual Machine..."
    echo "Daftar VM terdaftar:"
    VBoxManage list vms | awk -F'"' '{print NR". "$2}'
}

vm_info() {
    local vm_name="$1"
    if [ -z "$vm_name" ]; then
        echo "Usage: ./vm_ctl.sh info <nama_vm>"
        exit 1
    fi

    local info
    info=$(VBoxManage showvminfo "$vm_name" --machinereadable 2>/dev/null)
    
    if [ $? -ne 0 ] || [ -z "$info" ]; then
        echo "Error: VM '$vm_name' tidak ditemukan."
        exit 1
    fi

    local ram=$(echo "$info" | grep -E '^memory=' | cut -d'=' -f2)
    local vcpu=$(echo "$info" | grep -E '^cpus=' | cut -d'=' -f2)
    local state=$(echo "$info" | grep -E '^VMState=' | cut -d'=' -f2 | tr -d '"')

    echo "VM                : $vm_name"
    echo "RAM dialokasikan  : ${ram} MB"
    echo "vCPU dialokasikan : $vcpu"
    echo "Status saat ini   : $state"
}

start() {
    echo "Menyalakan VM '$2' secara headless..."
    VBoxManage startvm "$2" --type headless 
    echo "VM '$2' berhasil dinyalakan. Status: running"
}

stop() {
    echo "Mematikan VM '$2' secara aman..."
    VBoxManage controlvm "$2" acpipowerbutton 
    echo "VM '$2' berhasil dimatikan. Status: powered off"
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
    vm_list $1
elif [ "$1" == "info" ]; then
    vm_info "$2"
elif [ "$1" == "start" ]; then
    start $1 $2 
elif [ "$1" == "stop" ]; then
    stop $1 $2
elif [ "$1" == "snapshot" ]; then
    snapshot $1 $2 $3 $4
fi
