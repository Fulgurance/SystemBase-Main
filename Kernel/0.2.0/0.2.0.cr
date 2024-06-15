class Target < ISM::VirtualSoftware

    def install
        super

        ##{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}
        mainKernelSourcesPath = "/usr/src/#{mainKernelName}"

        makeDirectory("#{Ism.settings.rootPath}/usr/share/doc/")

        #Make link for the current kernel documentation
        makeLink(   target: "/usr/src/main-kernel-sources/Documentation",
                    path:   "#{Ism.settings.rootPath}/usr/share/doc/main-kernel-documentation",
                    type:   :symbolicLinkByOverwrite)

        #Make link for the current running kernel sources
        makeLink(   target: mainKernelSourcesPath,
                    path:   "#{Ism.settings.rootPath}/usr/src/main-kernel-sources",
                    type:   :symbolicLinkByOverwrite)

        #Generate headers
        makeSource( arguments:   "mrproper",
                    path: mainKernelSourcesPath)

        makeSource( arguments:  "headers",
                    path: mainKernelSourcesPath)

        ################################################################################
        #This method is temporary before a proper one is implemented to get directories#
        ################################################################################

        #Generate symlinks of the current kernel headers to /usr/include
        headerDirectories = [   "acpi",
                                "asm-generic",
                                "clocksource",
                                "crypto",
                                "drm",
                                "dt-bindings",
                                "generated",
                                "keys",
                                "kunit",
                                "kvm",
                                "linux",
                                "math-emu",
                                "media",
                                "memory",
                                "misc",
                                "net",
                                "pcmia",
                                "ras",
                                "rdma",
                                "rv",
                                "scsi",
                                "soc",
                                "sound",
                                "target",
                                "trace",
                                "uapi",
                                "ufs",
                                "vdso",
                                "video",
                                "xen"]

        headerDirectories.each do |headerDirectory|
            makeLink(   target: "/usr/src/#{mainKernelName}/include/#{headerDirectory}",
                        path:   "#{Ism.settings.rootPath}/usr/include/#{headerDirectory}",
                        type:   :symbolicLinkByOverwrite)
        end

        #Experimental
        #updateKernelOptionsDatabase
    end

end
