class Target < ISM::VirtualSoftware

    def install
        super

        #Generate headers
        makeSource(["mrproper"], path: mainKernelSourcesPath)
        makeSource(["headers"], path: mainKernelSourcesPath)

        #Make link for the current kernel documentation
        makeLink("/usr/src/main-kernel-sources/Documentation", "/usr/share/doc/main-kernel-documentation", :symbolicLinkByOverwrite)
        #Make link for the current running kernel sources
        makeLink("/usr/src/#{mainKernelName}", "/usr/src/main-kernel-sources", :symbolicLinkByOverwrite)

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
            makeLink("/usr/src/#{mainKernelName}/include/#{headerDirectory}", "/usr/include/#{headerDirectory}", :symbolicLinkByOverwrite)
        end

        #Experimental
        #updateKernelOptionsDatabase
    end

end
