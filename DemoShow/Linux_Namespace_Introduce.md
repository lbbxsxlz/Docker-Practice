# Linux Namespace Introduce

## Namespace
Linux Namespace是Linux提供的一种内核级别环境隔离的方法。很早以前的Unix有一个叫chroot的系统调用（通过修改根目录把用户jail到一个特定目录下），chroot提供了一种简单的隔离模式：chroot内部的文件系统无法访问外部的内容。Linux Namespace在此基础上，提供了对UTS、IPC、mount、PID、network、User等的隔离机制。

Linux Namespace 有如下种类，官方文档在这里[Namespace in Operation](https://lwn.net/Articles/531114/)

![Namespace种类](Namespace.jpg)
主要是三个系统调用:

clone() – 实现线程的系统调用，用来创建一个新的进程，并可以通过设计上述参数达到隔离。<br>
unshare() – 使某进程脱离某个namespace <br>
setns() – 把某进程加入到某个namespace <br>

本次的主题主要介绍clone系统调用。

## Test Environment
### what is docker ?
“Docker”是一家公司，这一词也会用于指代开源 Docker 项目。其中包含一系列可以从 Docker 官网下载和安装的工具，比如 Docker 服务端和 Docker 客户端。

![docker](docker.jpg)

该项目在 2017 年于 Austin 举办的 DockerCon 上正式命名为 Moby 项目。由于这次改名，GitHub 上的 docker/docker 库也被转移到了 [moby/moby](https://github.com/moby/moby)。

### Test Environment Prepare
使用docker构建了Ubuntu 16.04镜像，并在此基础上添加了gcc编译器。
Dockerfile如下：
```
FROM lbbxsxlz/ubuntu_16.04
LABEL maintainer="lbbxsxlz@gmail.com"
ENV REFRESHED_AT 2021-01-27
RUN apt-get update
RUN apt-get -y install gcc
RUN mkdir -p /opt/project
VOLUME /opt/project/
WORKDIR /opt/project/
CMD ["/bin/bash"]
```

构建命令：
```
docker build -t "lbbxsxlz/ubuntu_16.04_gcc" .
```

启动容器：
```
docker run -v $PWD/code:/opt/project --name demoShow --privileged -it lbbxsxlz/ubuntu_16.04_gcc
```
--privileged  特权模式，此主题中的验证都需要此特权。

## clone call
看下clone系统调用的代码，后续验证的代码均已此为基础。
```
#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/mount.h>
#include <stdio.h>
#include <sched.h>
#include <signal.h>
#include <unistd.h>

#define STACK_SIZE (1024 * 1024)

static char container_stack[STACK_SIZE];
char* const container_args[] = {
    "/bin/bash",
    NULL
};

int container_main(void* arg)
{
	printf("Test-Container - inside the container!\n");
	execv(container_args[0], container_args);
	printf("Something's wrong!\n");
	return 1;
}

int main()
{
	printf("Parent - start a container!\n");
	/*启用CLONE_NEWUTS Namespace隔离 */
	int container_pid = clone(container_main, container_stack+STACK_SIZE, SIGCHLD, NULL); 
	waitpid(container_pid, NULL, 0);
	printf("Parent - container stopped!\n");
	return 0;
}

```
在docker容器中编译此代码，运行程序。

![clone](clone.jpg)

上面的程序和pthread基本上是一样的玩法。但是，对于上面的程序，父子进程的进程空间是没有什么差别的，父进程能访问到的子进程也能。

## UTS Namespace
```
int container_main(void* arg)
{
	printf("Test-Container - inside the container!\n");
	sethostname("lbbxsxlz-container",19);
	execv(container_args[0], container_args);
	printf("Something's wrong!\n");
	return 1;
}

int main()
{
	printf("Parent - start a container!\n");
	/*启用CLONE_NEWUTS Namespace隔离 */
	int container_pid = clone(container_main, container_stack+STACK_SIZE, 
		CLONE_NEWUTS | SIGCHLD, NULL); 
	waitpid(container_pid, NULL, 0);
	printf("Parent - container stopped!\n");
	return 0;
}
```
运行添加UTS namespace flag的程序。

![uts](uts.jpg)

## IPC Namespace
IPC全称 Inter-Process Communication，是Unix/Linux下进程间通信的一种方式，IPC有共享内存、信号量、消息队列等方法。为了隔离，我们也需要把IPC给隔离开来，这样，只有在同一个Namespace下的进程才能相互通信。IPC需要有一个全局的ID，即然是全局的，那么就意味着我们的Namespace需要对这个ID隔离，不能让别的Namespace的进程看到。

要启动IPC隔离，我们只需要在调用clone时加上CLONE_NEWIPC参数就可以了。
```
int main()
{
	printf("Parent - start a container!\n");
	/*启用CLONE_NEWUTS、CLONE_NEWIPC Namespace隔离 */
	int container_pid = clone(container_main, container_stack+STACK_SIZE, 
		CLONE_NEWUTS | CLONE_NEWIPC | SIGCHLD, NULL); 
	waitpid(container_pid, NULL, 0);
	printf("Parent - container stopped!\n");
	return 0;
}
```

先在容器中创建一个IPC的Queue，效果如下：

![ipc1](ipc1.jpg)

我们先看运行之前的uts的隔离程序，看下结果，ipc未被隔离。

![ipc2](ipc2.jpg)

我们再运行，添加了IPC隔离的程序，发现IPC隔离生效了。

![ipc3](ipc3.jpg)

## PID Namespace
在uts隔离的基础上修改程序。
```
int container_main(void* arg)
{
    /* 查看子进程的PID，我们可以看到其输出子进程的 pid 为 1 */
    printf("Test-Container [%5d] - inside the container!\n", getpid());
    sethostname("lbbxsxlz-container",19);
    execv(container_args[0], container_args);
    printf("Something's wrong!\n");
    return 1;
}
int main()
{
    printf("Parent [%5d] - start a container!\n", getpid());
    /*启用CLONE_NEWUTS、CLONE_NEWPID Namespace隔离 */
    int container_pid = clone(container_main, container_stack+STACK_SIZE, 
            CLONE_NEWUTS | CLONE_NEWPID | SIGCHLD, NULL); 
    waitpid(container_pid, NULL, 0);
    printf("Parent - container stopped!\n");
    return 0;
}
```
运行结果如下：

![pid](pid.jpg)

在传统的UNIX系统中，PID为1的进程是init，地位非常特殊。他作为所有进程的父进程，有很多特权（比如：屏蔽信号等），另外，其还会为检查所有进程的状态，我们知道，如果某个子进程脱离了父进程（父进程没有wait它），那么init就会负责回收资源并结束这个子进程。所以，要做到进程空间的隔离，首先要创建出PID为1的进程，最好就像chroot那样，把子进程的PID在容器内变成1。

但是，我们会发现，在子进程的shell里输入ps,top等命令，我们还是可以看得到所有进程。说明并没有完全隔离。这是因为，像ps, top这些命令会去读/proc文件系统。/proc文件系统在父进程和子进程都是一样的，所以这些命令显示的东西都是一样的。

所以，我们还需要对文件系统进行隔离。

## Mount Namespace
在下面的程序中，我们在PID Namespace的基础上添加了Mount Namespace标志，并在子进程中重新mount了proc文件系统。
```
int container_main(void* arg)
{
    printf("Test-Container [%5d] - inside the container!\n", getpid());
    sethostname("lbbxsxlz-container",19);
    /* 重新mount proc文件系统到 /proc下 */
    system("mount -t proc proc /proc");
    execv(container_args[0], container_args);
    printf("Something's wrong!\n");
    return 1;
}
int main()
{
    printf("Parent [%5d] - start a container!\n", getpid());
    /* 启用UTS\PID\Mount Namespace - 增加CLONE_NEWNS参数 */
    int container_pid = clone(container_main, container_stack+STACK_SIZE, 
            CLONE_NEWUTS | CLONE_NEWPID | CLONE_NEWNS | SIGCHLD, NULL);
    waitpid(container_pid, NULL, 0);
    printf("Parent - container stopped!\n");
    return 0;
}
```

由于我们的测试均运行在容器上，容器本身的进程与proc文件系统都比较简单，直接运行程序并不能明显的看出效果，因此通过增加运行clone程序来使进程与proc文件系统稍稍变得复杂。测试结果如下：

![mount](mount.jpg)

在通过CLONE_NEWNS创建mount namespace后，父进程会把自己的文件结构复制给子进程中。而子进程中新的namespace中的所有mount操作都只影响自身的文件系统，而不对外界产生任何影响。这样可以做到比较严格地隔离。

## User Namespace

User Namespace主要是用了CLONE_NEWUSER的参数。使用了这个参数后，内部看到的UID和GID已经与外部不同了，默认显示为65534。那是因为容器找不到其真正的UID所以，设置上了最大的UID（其设置定义在/proc/sys/kernel/overflowuid）。

要把容器中的uid和真实系统的uid给映射在一起，需要修改 /proc/<pid>/uid_map 和 /proc/<pid>/gid_map 这两个文件。这两个文件的格式为：

ID-inside-ns ID-outside-ns length

其中：

第一个字段ID-inside-ns表示在容器显示的UID或GID，
第二个字段ID-outside-ns表示容器外映射的真实的UID或GID。
第三个字段表示映射的范围，一般填1，表示一一对应。

另外，需要注意的是：

写这两个文件的进程需要这个namespace中的CAP_SETUID (CAP_SETGID)权限（可参看Capabilities）
写入的进程必须是此user namespace的父或子的user namespace进程。
另外需要满如下条件之一：1）父进程将effective uid/gid映射到子进程的user namespace中，2）父进程如果有CAP_SETUID/CAP_SETGID权限，那么它将可以映射到父进程中的任一uid/gid。

```
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/mount.h>
//#include <sys/capability.h>
#include <stdio.h>
#include <sched.h>
#include <signal.h>
#include <unistd.h>

#define STACK_SIZE (1024 * 1024)

static char container_stack[STACK_SIZE];
char* const container_args[] = {
    "/bin/bash",
    NULL
};

int pipefd[2];

void set_map(char* file, int inside_id, int outside_id, int len) {
    FILE* mapfd = fopen(file, "w");
    if (NULL == mapfd) {
        perror("open file error");
        return;
    }
    fprintf(mapfd, "%d %d %d", inside_id, outside_id, len);
    fclose(mapfd);
}

void set_uid_map(pid_t pid, int inside_id, int outside_id, int len) {
    char file[256];
    sprintf(file, "/proc/%d/uid_map", pid);
    set_map(file, inside_id, outside_id, len);
}

void set_gid_map(pid_t pid, int inside_id, int outside_id, int len) {
    char file[256];
    sprintf(file, "/proc/%d/gid_map", pid);
    set_map(file, inside_id, outside_id, len);
}

int container_main(void* arg)
{

    printf("Test-Container [%5d] - inside the container!\n", getpid());

    printf("Test-Container: eUID = %ld;  eGID = %ld, UID=%ld, GID=%ld\n",
            (long) geteuid(), (long) getegid(), (long) getuid(), (long) getgid());

    /* 等待父进程通知后再往下执行（进程间的同步） */
    char ch;
    close(pipefd[1]);
    read(pipefd[0], &ch, 1);

    printf("Test-Container [%5d] - setup hostname!\n", getpid());
    //set hostname
    sethostname("lbbxsxlz-container",19);

    //remount "/proc" to make sure the "top" and "ps" show container's information
    mount("proc", "/proc", "proc", 0, NULL);

    execv(container_args[0], container_args);
    printf("Something's wrong!\n");
    return 1;
}

int main()
{
    const int gid=getgid(), uid=getuid();

    printf("Parent: eUID = %ld;  eGID = %ld, UID=%ld, GID=%ld\n",
            (long) geteuid(), (long) getegid(), (long) getuid(), (long) getgid());

    pipe(pipefd);
 
    printf("Parent [%5d] - start a container!\n", getpid());

    int container_pid = clone(container_main, container_stack+STACK_SIZE, 
            CLONE_NEWUTS | CLONE_NEWPID | CLONE_NEWNS | CLONE_NEWUSER | SIGCHLD, NULL);

    
    printf("Parent [%5d] - Container [%5d]!\n", getpid(), container_pid);

    //To map the uid/gid, 
    //   we need edit the /proc/PID/uid_map (or /proc/PID/gid_map) in parent
    //The file format is
    //   ID-inside-ns   ID-outside-ns   length
    //if no mapping, 
    //   the uid will be taken from /proc/sys/kernel/overflowuid
    //   the gid will be taken from /proc/sys/kernel/overflowgid
    set_uid_map(container_pid, 0, uid, 1);
    set_gid_map(container_pid, 0, gid, 1);

    printf("Parent [%5d] - user/group mapping done!\n", getpid());

    /* 通知子进程 */
    close(pipefd[1]);

    waitpid(container_pid, NULL, 0);
    printf("Parent - container stopped!\n");
    return 0;
}

```

我们用了一个pipe来对父子进程进行同步，为什么要这样做？因为子进程中有一个execv的系统调用，这个系统调用会把当前子进程的进程空间给全部覆盖掉，我们希望在execv之前就做好user namespace的uid/gid的映射，这样，execv运行的/bin/bash就会因为我们设置了uid为0的inside-uid而变成#号的提示符。

程序的运行结果：
![user](user.jpg)

以上程序是在宿主机上运行的，并不是在容器中运行的。

## summarize
以上是本次主题分享的内容，主要介绍了五种Namespace隔离机制，未涉及到Network Namespace，这个以后有机会再分享吧。另外NameSpace涉及到不少系统调用与用户权限相关的内容，这部分内容需要积累沉淀，一起加油哈！