class Target < ISM::VirtualSoftware

    def install
        super

        recordSelectedKernel

        makeDirectory("#{Ism.settings.rootPath}/usr/share/doc/")
        makeDirectory("#{Ism.settings.rootPath}/usr/include")

        #Make link for the current kernel documentation
        makeLink(   target: "../../src/main-kernel-sources/Documentation",
                    path:   "#{Ism.settings.rootPath}/usr/share/doc/main-kernel-documentation",
                    type:   :symbolicLinkByOverwrite)

        #Make link for the current running kernel sources
        makeLink(   target: "#{mainKernelName}",
                    path:   "#{Ism.settings.rootPath}/usr/src/main-kernel-sources",
                    type:   :symbolicLinkByOverwrite)

        #Generate headers
        makeSource( arguments:   "mrproper",
                    path: "#{Ism.settings.rootPath}/usr/src/main-kernel-sources")

        makeSource( arguments:  "headers",
                    path: "#{Ism.settings.rootPath}/usr/src/main-kernel-sources")

        ################################################################################
        #This method is temporary before a proper one is implemented to get directories#
        ################################################################################

        #Generate symlinks of the current kernel headers to /usr/include
        headerDirectories = [   "asm",
                                "asm-generic",
                                "drm",
                                "linux",
                                "misc",
                                "mtd",
                                "rdma",
                                "regulator",
                                "scsi",
                                "sound",
                                "video",
                                "xen"]

        # headerDirectories.each do |headerDirectory|
        #     makeLink(   target: "../src/main-kernel-sources/usr/include/#{headerDirectory}",
        #                 path:   "#{Ism.settings.rootPath}/usr/include/#{headerDirectory}",
        #                 type:   :symbolicLinkByOverwrite)
        # end

        headerDirectories.each do |headerDirectory|
            copyDirectory(  "#{Ism.settings.rootPath}/usr/src/main-kernel-sources/usr/include/#{headerDirectory}",
                            "#{Ism.settings.rootPath}/usr/include/#{headerDirectory}")
        #     makeLink(   target: "../src/main-kernel-sources/usr/include/#{headerDirectory}",
        #                 path:   "#{Ism.settings.rootPath}/usr/include/#{headerDirectory}",
        #                 type:   :symbolicLinkByOverwrite)
        end

        #Experimental
        #updateKernelOptionsDatabase
    end

end
