#include <stdio.h>

int main() {
    int disk_usage, memory_usage;
    
    if (scanf("%d %d", &disk_usage, &memory_usage) != 2) {
        printf("ERROR\n");
        return 1;
    }
    
    const char *disk_status, *disk_detail;
    const char *mem_status, *mem_detail;
    
    // Disk (>= 90 Fail, >= 75 Warn)
    if (disk_usage >= 90) {
        disk_status = "FAIL";
        disk_detail = "Kritis";
    } else if (disk_usage >= 75) {
        disk_status = "WARN";
        disk_detail = "Mulai_penuh";
    } else {
        disk_status = "PASS";
        disk_detail = "Aman";
    }
    
    // Memory (>= 90 Fail, >= 75 Warn)
    if (memory_usage >= 90) {
        mem_status = "FAIL";
        mem_detail = "Kritis";
    } else if (memory_usage >= 75) {
        mem_status = "WARN";
        mem_detail = "Mulai_penuh";
    } else {
        mem_status = "PASS";
        mem_detail = "Aman";
    }
    
    printf("%s %s %s %s\n", disk_status, disk_detail, mem_status, mem_detail);
    
    return 0;
}