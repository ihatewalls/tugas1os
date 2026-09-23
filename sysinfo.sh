echo "==================================="
echo "     TUGAS 1 OS - KELOMPOK B7     "
echo "==================================="
echo "Mengecek sistem..."
echo ""

# 1. Info OS / Kernel
if [ -f /etc/os-release ]; then
    
    OS_NAME=$(grep -E '^PRETTY_NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
else
    OS_NAME="Linux (Unknown Distro)"
fi

KERNEL_VER=$(uname -r)
OS_INFO="$OS_NAME (Kernel $KERNEL_VER)"

# 2. Jumlah Akun Pengguna Biasa
REGULAR_USERS=$(awk -F: '$3 >= 1000 && $1 != "nobody" {count++} END {print count+0}' /etc/passwd 2>/dev/null || echo 0)

# 3. Jumlah Proses Berjalan

RUNNING_PROCESSES=$(ps -e --no-headers 2>/dev/null | wc -l | tr -d ' ')

# 4. Deteksi Mesin Virtual vs Fisik
if command -v systemd-detect-virt &>/dev/null; then
    VIRT_TYPE=$(systemd-detect-virt)
    if [ "$VIRT_TYPE" = "none" ]; then
        VIRT_STATUS="Mesin Fisik"
    else
        case "$VIRT_TYPE" in
            oracle|vbox)
                VIRT_STATUS="Terdeteksi (VirtualBox)"
                ;;
            *)
                VIRT_STATUS="Terdeteksi ($VIRT_TYPE)"
                ;;
        esac
    fi
else
    if grep -qi "virtualbox" /sys/class/dmi/id/product_name 2>/dev/null || grep -qi "hypervisor" /proc/cpuinfo 2>/dev/null; then
        VIRT_STATUS="Terdeteksi (VirtualBox)"
    else
        VIRT_STATUS="Mesin Fisik"
    fi
fi

# Tampilkan Output Sesuai Spesifikasi Dokumen
echo "OS/Kernel       : $OS_INFO"
echo "Akun pengguna   : $REGULAR_USERS akun"
echo "Proses berjalan : $RUNNING_PROCESSES proses"
echo "Virtualisasi    : $VIRT_STATUS"

# Mapping variabel ke format Report
os_info="$OS_NAME"
kernel_info="$KERNEL_VER"
user_count="$REGULAR_USERS"
proc_count="$RUNNING_PROCESSES"
virt_display="$VIRT_STATUS"

# Ambil Output Resource Check jika program sudah dikompilasi
if [ -x "./resource_check" ]; then
    read -r disk_status disk_detail mem_status mem_detail <<< $(echo "$disk_usage $mem_usage" | ./resource_check)
fi

# Remove (_)
disk_detail="${disk_detail//_/ }"
mem_detail="${mem_detail//_/ }"
echo ""
echo "Fitur Tambahan:"
uptime_info=$(uptime -p | sed 's/up//')
awk -v uptime="$uptime_info" 'BEGIN{printf "Uptime VM: %s\n", uptime}'  

# File Report
cat <<EOF > sysinfo_report.txt
====================================================================
TUGAS 1 OS - KELOMPOK B07
====================================================================
| Check Category | Item               | Status | Details
--------------------------------------------------------------------
| OS             | $os_info | PASS   | Kernel $kernel_info
| Users          | Regular accounts   | PASS   | $user_count akun
| Processes      | Running            | PASS   | $proc_count proses berjalan
| Virtualization | Hypervisor         | PASS   | $virt_display
--------------------------------------------------------------------
| Disk           | $disk_usage%                | $disk_status   | $disk_detail
| Memori         | $mem_usage%                | $mem_status   | $mem_detail
| Uptime         | VM Uptime Check    | PASS   | $uptime_info
====================================================================
EOF
