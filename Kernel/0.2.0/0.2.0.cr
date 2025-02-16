class Target < ISM::VirtualSoftware

    def install
        super

        recordSelectedKernel
        updateKernelSymlinks

        makeDirectory("#{Ism.settings.rootPath}/usr/share/doc/")
        makeDirectory("#{Ism.settings.rootPath}/usr/include")

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
