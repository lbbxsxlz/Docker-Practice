/*
cgroup mem test
# 创建memory cgroup
$ mkdir /sys/fs/cgroup/memory/lbbxsxlz
$ echo 64k > /sys/fs/cgroup/memory/lbbxsxlz/memory.limit_in_bytes
# 把下面的进程的pid加入这个cgroup
$ echo [pid] > /sys/fs/cgroup/memory/lbbxsxlz/tasks
*/
#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

int main(void)
{
    int size = 0;
    int chunk_size = 512;
    void *p = NULL;

    while(1) {

        if ((p = malloc(p, chunk_size)) == NULL) {
            printf("out of memory!!\n");
            break;
        }
        memset(p, 1, chunk_size);
        size += chunk_size;
        printf("[%d] - memory is allocated [%8d] bytes \n", getpid(), size);
        sleep(1);
    }
    return 0;
}
