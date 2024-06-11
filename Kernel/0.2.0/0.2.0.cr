class Target < ISM::VirtualSoftware

    def configure
        super

        if option("Pass1")
            makeSource(["mrproper"], path: mainKernelSourcesPath)
        end
    end

    def build
        super

        if option("Pass1")
            makeSource(["headers"], path: mainKernelSourcesPath)
        end
    end

    def prepareInstallation
        super

        #Make link for the current kernel documentation
        makeLink("/usr/src/main-kernel-sources/Documentation", "/usr/share/doc/main-kernel-documentation", :symbolicLinkByOverwrite)

        #Make link for the current running kernel sources
        makeLink("/usr/src/#{mainKernelName}", "/usr/src/main-kernel-sources", :symbolicLinkByOverwrite)

        linkKernelHeaders
    end

    def install
        super

        if !option("Pass1")
            updateKernelOptionsDatabase
        end
    end

end
