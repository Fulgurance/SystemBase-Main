class Target < ISM::Software

    def download
    end

    def check
    end

    def extract
    end

    def patch
    end

    def prepare
    end

    def configure
    end

    def build
    end

    def prepareInstallation
        if option("Pass1") || option("Pass2")
            super
        end

        if option("Pass1")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}var")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}lib64")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/sbin")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.sourcesPath}")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.toolsPath}")
        end

        if option("Pass2")
            newDirs = [ "/dev","/proc","/sys","/run","/boot","/home","/mnt","/opt","/srv","/etc/opt",
                        "/etc/sysconfig","/lib/firmware","/media/floppy","/media/cdrom","/usr/share/color",
                        "/usr/share/dict","/usr/share/doc","/usr/share/info","/usr/share/locale",
                        "/usr/share/man","/usr/share/man1","/usr/share/man2","/usr/share/man3",
                        "/usr/share/man4","/usr/share/man5","/usr/share/man6","/usr/share/man7",
                        "/usr/share/man8","/usr/share/misc","/usr/share/terminfo","/usr/share/zoneinfo",
                        "/usr/local/share/color","/usr/local/share/dict","/usr/local/share/doc",
                        "/usr/local/share/info","/usr/local/share/locale","/usr/local/share/man",
                        "/usr/local/share/man1","/usr/local/share/man2","/usr/local/share/man3",
                        "/usr/local/share/man4","/usr/local/share/man5","/usr/local/share/man6",
                        "/usr/local/share/man7","/usr/local/share/man8","/usr/local/share/misc",
                        "/usr/local/share/terminfo","/usr/local/share/zoneinfo","/var/cache","/var/local",
                        "/var/log","/var/mail","/var/opt","/var/spool","/var/lib/color","/var/lib/misc",
                        "/var/lib/locate","/root","/tmp","/var/tmp","/dev","/proc","/sys","/run","/boot",
                        "/home","/mnt","/opt","/srv","/etc/opt","/etc/sysconfig","/lib/firmware",
                        "/media/floppy","/media/cdrom","/usr/share/color","/usr/share/dict","/usr/share/doc",
                        "/usr/share/info","/usr/share/locale","/usr/share/man","/usr/share/man1",
                        "/usr/share/man2","/usr/share/man3","/usr/share/man4","/usr/share/man5",
                        "/usr/share/man6","/usr/share/man7","/usr/share/man8","/usr/share/misc",
                        "/usr/share/terminfo","/usr/share/zoneinfo","/usr/local/share/color",
                        "/usr/local/share/dict","/usr/local/share/doc","/usr/local/share/info",
                        "/usr/local/share/locale","/usr/local/share/man","/usr/local/share/man1",
                        "/usr/local/share/man2","/usr/local/share/man3","/usr/local/share/man4",
                        "/usr/local/share/man5","/usr/local/share/man6","/usr/local/share/man7",
                        "/usr/local/share/man8","/usr/local/share/misc","/usr/local/share/terminfo",
                        "/usr/local/share/zoneinfo","/var/cache","/var/local","/var/log","/var/mail",
                        "/var/opt","/var/spool","/var/lib/color","/var/lib/misc","/var/lib/locate","/root",
                        "/tmp","/var/tmp"]

            changeOwnerDirs = [ "/usr","/lib","/lib64","/var","/etc","/bin","/sbin","#{Ism.settings.toolsPath}","#{Ism.settings.sourcesPath}"]

            emptyFiles = ["/var/log/btmp","/var/log/lastlog","/var/log/faillog","/var/log/wtmp"]

            newDirs.each do |dir|
                makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{dir}")
                if dir == "/root"
                    setPermissions("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{dir}",0o0750)
                end
                if dir == "/tmp" || dir == "/var/tmp"
                    setPermissions("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{dir}",0o1777)
                end
            end

            changeOwnerDirs.each do |dir|
                setOwnerRecursively("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{dir}","root","root")
            end

            hostsData = <<-CODE
            127.0.0.1  localhost $(hostname)
            ::1        localhost
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/hosts",hostsData)

            passwdData = <<-CODE
            root:x:0:0:root:/root:/bin/bash
            bin:x:1:1:bin:/dev/null:/bin/false
            daemon:x:6:6:Daemon User:/dev/null:/bin/false
            messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/bin/false
            uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/bin/false
            nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/passwd",passwdData)

            groupData = <<-CODE
            root:x:0:
            bin:x:1:daemon
            sys:x:2:
            kmem:x:3:
            tape:x:4:
            tty:x:5:
            daemon:x:6:
            floppy:x:7:
            disk:x:8:
            lp:x:9:
            dialout:x:10:
            audio:x:11:
            video:x:12:
            utmp:x:13:
            usb:x:14:
            cdrom:x:15:
            adm:x:16:
            messagebus:x:18:
            input:x:24:
            mail:x:34:
            kvm:x:61:
            uuidd:x:80:
            wheel:x:97:
            nogroup:x:99:
            users:x:999:
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/group",groupData)

            emptyFiles.each do |file|
                generateEmptyFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{file}")
                if file == "/var/log/lastlog"
                    setOwner("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{file}",-1,"utmp")
                    setPermissions("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{file}",0o664)
                end
                if file == "/var/log/btmp"
                    setPermissions("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{file}",0o600)
                end
            end
        end

        if option("Pass3")
            deleteDirectoryRecursively("#{Ism.settings.rootPath}usr/share/info")
            deleteDirectoryRecursively("#{Ism.settings.rootPath}usr/share/man")
            deleteDirectoryRecursively("#{Ism.settings.rootPath}usr/share/doc")
            deleteAllFilesRecursivelyFinishing("#{Ism.settings.rootPath}usr/lib",".la")
            deleteAllFilesRecursivelyFinishing("#{Ism.settings.rootPath}usr/libexec",".la")
            deleteDirectoryRecursively("#{Ism.settings.rootPath}tools")
        end
    end

    def install
        if option("Pass1") || option("Pass2")
            super
        end

        if option("Pass1")
            makeLink("usr/bin","#{Ism.settings.rootPath}bin",:symbolicLink)
            makeLink("usr/lib","#{Ism.settings.rootPath}lib",:symbolicLink)
            makeLink("usr/sbin","#{Ism.settings.rootPath}sbin",:symbolicLink)
        end

        if option("Pass2")
            makeLink("/run","#{Ism.settings.rootPath}var/run",:symbolicLinkByOverwrite)
            makeLink("/run/lock","#{Ism.settings.rootPath}var/lock",:symbolicLinkByOverwrite)
            makeLink("/proc/self/mounts","#{Ism.settings.rootPath}etc/mtab",:symbolicLink)
        end
    end

end
