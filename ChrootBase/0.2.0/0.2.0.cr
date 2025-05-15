class Target < ISM::VirtualSoftware

    def showInformations
        super

        showInfo("Now the system is able to handle the chroot.")
        showInfo("Firstly, mount all necessary virtual kernel filesystems by the following commands:")
        showInfoCode("mount --types proc /proc /mnt/ism/proc")
        showInfoCode("mount --rbind /sys /mnt/ism/sys")
        showInfoCode("mount --rbind /dev /mnt/ism/dev")
        showInfoCode("mount --bind /run /mnt/ism/run ")
        showInfo("Then, you can enable the secure mode and continue your installation.")
        showInfoCode("sudo ism settings -esm")
    end

end
