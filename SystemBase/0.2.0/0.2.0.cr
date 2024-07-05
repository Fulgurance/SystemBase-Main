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

    @@changeOwnerDirs = [ "/usr","/lib64","/var","/etc","/bin","/sbin","/tmp","/boot","#{ISM::Default::Path::ToolsDirectory}","#{ISM::Default::Path::SourcesDirectory}","/.","/.."]

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
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/sbin")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.sourcesPath}")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.toolsPath}")

            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib64")

            if option("Multilib")
                makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib32")
                makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/libx32")
            end

            lsbReleaseData = <<-CODE
            DISTRIB_ID="#{Ism.settings.systemId}"
            DISTRIB_RELEASE="#{Ism.settings.systemRelease}"
            DISTRIB_CODENAME="#{Ism.settings.systemCodeName}"
            DISTRIB_DESCRIPTION="#{Ism.settings.systemDescription}"
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/lsb-release",lsbReleaseData)

            osReleaseData = <<-CODE
            NAME="#{Ism.settings.systemName}"
            VERSION="#{Ism.settings.systemVersion}"
            ID="#{Ism.settings.systemId}"
            VERSION_ID="#{Ism.settings.systemVersionId}"
            PRETTY_NAME="#{Ism.settings.systemFullName}"
            ANSI_COLOR="#{Ism.settings.systemAnsiColor}"
            CPE_NAME="#{Ism.settings.systemCpeName}"
            HOME_URL="#{Ism.settings.systemHomeUrl}"
            SUPPORT_URL="#{Ism.settings.systemSupportUrl}"
            BUG_REPORT_URL="#{Ism.settings.systemBugReportUrl}"
            PRIVACY_POLICY_URL="#{Ism.settings.systemPrivacyPolicyUrl}"
            BUILD_ID="#{Ism.settings.systemBuildId}"
            VARIANT="#{Ism.settings.systemVariant}"
            VARIANT_ID="#{Ism.settings.systemVariantId}"
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
            deleteDirectory("/usr/share/info")
            deleteDirectory("/usr/share/man")
            deleteDirectory("/usr/share/doc")
            deleteDirectory("/tools")

            deleteAllFilesRecursivelyFinishing( path:       "/usr/lib",
                                                extensions: ["la"])
            deleteAllFilesRecursivelyFinishing( path:       "/usr/libexec",
                                                extensions: ["la"])

            if option("Multilib")
                deleteAllFilesRecursivelyFinishing( path:       "/usr/lib32",
                                                    extensions: ["la"])
                deleteAllFilesRecursivelyFinishing( path:       "/usr/libx32",
                                                    extensions: ["la"])
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
            makeLink(   target: "usr/bin",
                        path:   "#{Ism.settings.rootPath}/bin",
                        type:   :symbolicLink)

            makeLink(   target: "usr/sbin",
                        path:   "#{Ism.settings.rootPath}/sbin",
                        type:   :symbolicLink)

            makeLink(   target: "usr/lib",
                        path:   "#{Ism.settings.rootPath}/lib",
                        type:   :symbolicLink)

            #Set the main architecture
            makeLink(   target: "lib64",
                        path:   "#{Ism.settings.rootPath}/usr/lib",
                        type:   :symbolicLink)

            makeLink(   target: "/usr/lib64",
                        path:   "#{Ism.settings.rootPath}/lib64",
                        type:   :symbolicLink)

            if option("Multilib")
                makeLink(   target: "usr/lib32",
                            path:   "#{Ism.settings.rootPath}/lib32",
                            type:   :symbolicLink)
                makeLink(   target: "usr/libx32",
                            path:   "#{Ism.settings.rootPath}/libx32",
                            type:   :symbolicLink)
            end
        end

        if option("Pass2")
            @@newDirs.each do |dir|
                if dir == "/root"
                    runChmodCommand("0750 #{Ism.settings.rootPath}#{dir}")
                end
                if dir == "/tmp" || dir == "/var/tmp"
                    runChmodCommand("1777 #{Ism.settings.rootPath}#{dir}")
                end
            end

            @@changeOwnerDirs.each do |dir|
                runChownCommand("-R root:root #{Ism.settings.rootPath}#{dir}")
                runChownCommand("-R root:root #{Ism.settings.rootPath}#{dir}")
            end

            if option("Multilib")
                runChownCommand("-R root:root #{Ism.settings.rootPath}/lib32")
                runChownCommand("-R root:root #{Ism.settings.rootPath}/lib32")
            end

            @@emptyFiles.each do |file|
                if file == "/var/log/lastlog"
                    runChownCommand(":utmp #{Ism.settings.rootPath}#{file}")
                    runChmodCommand("0664 #{Ism.settings.rootPath}#{file}")
                end
                if file == "/var/log/btmp"
                    runChmodCommand("0600 #{Ism.settings.rootPath}#{file}")
                end
            end

            makeLink(   target: "/run",
                        path:   "#{Ism.settings.rootPath}var/run",
                        type:   :symbolicLinkByOverwrite)

            makeLink(   target: "/run/lock",
                        path:   "#{Ism.settings.rootPath}var/lock",
                        type:   :symbolicLinkByOverwrite)

            makeLink(   target: "/proc/self/mounts",
                        path:   "#{Ism.settings.rootPath}etc/mtab",
                        type:   :symbolicLink)
        end
    end

    def clean
    end

end
