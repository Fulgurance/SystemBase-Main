class Target < ISM::ComponentSoftware

    def install
        super

        recordSelectedKernel
        updateKernelSymlinks
        updateKernelOptionsDatabase
    end

end
