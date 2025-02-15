class Target < ISM::VirtualSoftware

    def install
        super

        recordSelectedKernel

        makeDirectory("#{Ism.settings.rootPath}/usr/share/doc/")
        makeDirectory("#{Ism.settings.rootPath}/usr/include")

        #Make link for the current running kernel sources
        makeLink(   target: "#{mainKernelName}",
                    path:   "#{Ism.settings.rootPath}/usr/src/main-kernel-sources",
                    type:   :symbolicLinkByOverwrite)

        #Make link for the current running kernel source headers
        makeLink(   target: "#{mainKernelHeadersName}",
                    path:   "#{Ism.settings.rootPath}/usr/src/main-kernel-sources-headers",
                    type:   :symbolicLinkByOverwrite)

        #Make link for the current kernel documentation
        makeLink(   target: "main-kernel-sources/Documentation",
                    path:   "#{Ism.settings.rootPath}/usr/share/doc/main-kernel-documentation",
                    type:   :symbolicLinkByOverwrite)

        #Generate headers
        makeSource( arguments:   "clean",
                    path: "#{Ism.settings.rootPath}/usr/src/#{mainKernelName}")

        makeSource( arguments:  "headers",
                    path: "#{Ism.settings.rootPath}/usr/src/#{mainKernelName}")

        #Generate symlinks of the current kernel headers to /usr/include
        headerPath = "#{Ism.settings.rootPath}/usr/src/main-kernel-sources-headers/usr/include/"
        headerDirectories = Dir.children(headerPath).select { |entry| File.directory?("#{headerPath}/#{entry}") }

        headerDirectories.each do |headerDirectory|
             makeLink(   target: "../src/main-kernel-sources-headers/#{headerDirectory}",
                         path:   "#{Ism.settings.rootPath}/usr/include/#{headerDirectory}",
                         type:   :symbolicLinkByOverwrite)
        end

        updateKernelOptionsDatabase
    end

end
