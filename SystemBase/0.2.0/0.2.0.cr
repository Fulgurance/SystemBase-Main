class Target < ISM::Software

    @@newDirs = ["/dev","/proc","/sys","/run","/boot","/home","/mnt","/opt","/srv","/etc/opt",
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

    @@changeOwnerDirs = [ "/usr","/lib","/lib64","/var","/etc","/bin","/sbin","/tmp","/boot","#{ISM::Default::Path::ToolsDirectory}","#{ISM::Default::Path::SourcesDirectory}","/.","/.."]

    @@emptyFiles = ["/var/log/btmp","/var/log/lastlog","/var/log/faillog","/var/log/wtmp"]

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

            if option("Multilib")
                makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib32")
                makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/libx32")
            end

            lsbReleaseData = <<-CODE
            DISTRIB_ID=
            DISTRIB_RELEASE=
            DISTRIB_CODENAME=
            DISTRIB_DESCRIPTION=
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/lsb-release",lsbReleaseData)

            osReleaseData = <<-CODE
            NAME=
            VERSION=
            ID=
            VERSION_ID=
            PRETTY_NAME=
            ANSI_COLOR=
            CPE_NAME=
            HOME_URL=
            SUPPORT_URL=
            BUG_REPORT_URL=
            PRIVACY_POLICY_URL=
            BUILD_ID=
            VARIANT=
            VARIANT_ID=
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/os-release",osReleaseData)
        end

        if option("Pass2")
            @@newDirs.each do |dir|
                makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{dir}")
            end

            hostsData = <<-CODE
            127.0.0.1  localhost $(hostname)
            ::1        localhost
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/hosts",hostsData)

            @@emptyFiles.each do |file|
                generateEmptyFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{file}")
            end
        end

        if option("Pass3")
            deleteDirectory("#{Ism.settings.rootPath}usr/share/info")
            deleteDirectory("#{Ism.settings.rootPath}usr/share/man")
            deleteDirectory("#{Ism.settings.rootPath}usr/share/doc")
            deleteAllFilesRecursivelyFinishing("#{Ism.settings.rootPath}usr/lib",".la")
            deleteAllFilesRecursivelyFinishing("#{Ism.settings.rootPath}usr/libexec",".la")
            deleteDirectory("#{Ism.settings.rootPath}tools")

            if option("Multilib")
                deleteAllFilesRecursivelyFinishing("#{Ism.settings.rootPath}usr/lib32",".la")
                deleteAllFilesRecursivelyFinishing("#{Ism.settings.rootPath}usr/libx32",".la")
            end
        end
    end

    def install
        if option("Pass1") || option("Pass2")
            super
        else
            Ism.addInstalledSoftware(@information)
        end

        if option("Pass1")
            makeLink("usr/bin","#{Ism.settings.rootPath}bin",:symbolicLink)
            makeLink("usr/lib","#{Ism.settings.rootPath}lib",:symbolicLink)
            makeLink("usr/sbin","#{Ism.settings.rootPath}sbin",:symbolicLink)

            if option("Multilib")
                makeLink("usr/lib32","#{Ism.settings.rootPath}lib32",:symbolicLink)
                makeLink("usr/libx32","#{Ism.settings.rootPath}libx32",:symbolicLink)
            end
        end

        if option("Pass2")
            @@newDirs.each do |dir|
                if dir == "/root"
                    setPermissions("#{Ism.settings.rootPath}#{dir}",0o0750)
                end
                if dir == "/tmp" || dir == "/var/tmp"
                    setPermissions("#{Ism.settings.rootPath}#{dir}",0o1777)
                end
            end

            @@changeOwnerDirs.each do |dir|
                setOwnerRecursively("#{Ism.settings.rootPath}#{dir}","root","root")
            end

            if option("Multilib")
                setOwnerRecursively("#{Ism.settings.rootPath}/lib32","root","root")
                setOwnerRecursively("#{Ism.settings.rootPath}/libx32","root","root")
            end

            @@emptyFiles.each do |file|
                if file == "/var/log/lastlog"
                    setOwner("#{Ism.settings.rootPath}#{file}",-1,"utmp")
                    setPermissions("#{Ism.settings.rootPath}#{file}",0o664)
                end
                if file == "/var/log/btmp"
                    setPermissions("#{Ism.settings.rootPath}#{file}",0o600)
                end
            end

            makeLink("/run","#{Ism.settings.rootPath}var/run",:symbolicLinkByOverwrite)
            makeLink("/run/lock","#{Ism.settings.rootPath}var/lock",:symbolicLinkByOverwrite)
            makeLink("/proc/self/mounts","#{Ism.settings.rootPath}etc/mtab",:symbolicLink)
        end
    end

    def clean
    end

end
