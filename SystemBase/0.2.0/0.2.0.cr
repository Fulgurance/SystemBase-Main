class Target < ISM::SemiVirtualSoftware

    @@newDirs = ["/dev","/proc","/sys","/run","/boot","/home","/mnt","/opt","/srv","/etc/opt",
                "/etc/sysconfig","/lib/firmware","/lib/locale","/media/floppy","/media/cdrom",
                "/usr/share/color","/usr/share/dict","/usr/share/locale",
                "/usr/share/man1","/usr/share/man2","/usr/share/man3",
                "/usr/share/man4","/usr/share/man5","/usr/share/man6","/usr/share/man7",
                "/usr/share/man8","/usr/share/misc","/usr/share/terminfo","/usr/share/zoneinfo",
                "/var/cache","/var/mail","/var/opt","/var/spool","/var/lib/color","/var/log",
                "/var/lib/misc","/var/lib/locate","/root","/tmp","/var/tmp","/dev/shm"]

    @@emptyFiles = ["/var/log/btmp","/var/log/lastlog","/var/log/faillog","/var/log/wtmp"]

    def prepareInstallation
        super

        if option("Pass1")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}var/log/ism")
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

            makeLink(   target: "usr/bin",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/bin",
                        type:   :symbolicLink)

            makeLink(   target: "usr/sbin",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/sbin",
                        type:   :symbolicLink)

            makeLink(   target: "usr/lib",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/lib",
                        type:   :symbolicLink)

            #Set the main architecture
            makeLink(   target: "lib64",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib",
                        type:   :symbolicLink)

            makeLink(   target: "usr/lib64",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/lib64",
                        type:   :symbolicLink)

            if option("Multilib")
                makeLink(   target: "usr/lib32",
                            path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/lib32",
                            type:   :symbolicLink)
                makeLink(   target: "usr/libx32",
                            path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/libx32",
                            type:   :symbolicLink)
            end

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

            makeLink(   target: "/run",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}var/run",
                        type:   :symbolicLinkByOverwrite)

            makeLink(   target: "/run/lock",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}var/lock",
                        type:   :symbolicLinkByOverwrite)

            makeLink(   target: "/proc/self/mounts",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/mtab",
                        type:   :symbolicLink)
        end

    end

    def deploy
        super

        if option("Pass2")
            prepareChrootFileSystem
        end

        if !passEnabled
            recordCrossToolchainAsFullyBuilt

            [   "/sources",
                "/tools",
                #"/var/ism",
                "/var/lib/ism",
                "/tmp/ism",
                "/var/log/ism"].each do |file|
                runChownCommand("-R ism:ism #{file}")
                runChmodCommand("-R 0755 #{file}")
            end

            [   "/tmp",
                "/var/tmp",
                "/dev/shm"].each do |file|
                runChownCommand("root:root #{file}")
                runChmodCommand("1777 #{file}")
            end

            runChownCommand("root:root /root")
            runChmodCommand("0750 /root")

            runChownCommand("root:utmp /var/log/lastlog")
            runChmodCommand("0664 /root")

            runChownCommand("root:root /var/log/btmp")
            runChmodCommand("0600 /root")

            [   "/lib32",
                "/libx32",
                "/lib64",
                "/usr",
                "/var",
                "/etc",
                "/bin",
                "/sbin",
                "/boot"].each do |file|
                runChownCommand("root:root #{file}")
                runChmodCommand("0755 #{file}")
            end
        end

    end

end
