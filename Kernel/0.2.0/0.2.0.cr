class Target < ISM::VirtualSoftware

    def install
        super

        recordSelectedKernel
        updateKernelSymlinks
        updateKernelOptionsDatabase
    end

end
