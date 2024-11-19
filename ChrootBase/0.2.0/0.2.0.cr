class Target < ISM::VirtualSoftware

    def install
        super

        #Install a fallback language by default
        runLocaledefCommand("-i C -f UTF-8 C.UTF-8")
    end

end
