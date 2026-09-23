vm_list() {
    echo "Memindai daftar Virtual Machine..."
    echo "Daftar VM terdaftar:"
    VBoxManage list vms | awk -F'"' '{print NR". "$2}'
}