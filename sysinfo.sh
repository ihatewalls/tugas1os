# Ambil Output
read -r disk_status disk_detail mem_status mem_detail <<< $(echo "$disk_usage $mem_usage" | ./resource_check)

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
