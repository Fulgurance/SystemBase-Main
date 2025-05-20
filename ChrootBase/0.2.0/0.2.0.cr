class Target < ISM::VirtualSoftware

    def deploy
        recordHandleChroot
    end

    def showInformations
        super

        showInfo("Now the system is able to handle the chroot.")

        showInfo("Firstly, set the owners as root for the new system:")
        showInfoCode("sudo chown -R root:root /mnt/ism")

        showInfo("Set proper rights for ism tree:")
        showInfoCode("sudo chown -R ism:ism /mnt/ism/var/ism")
        showInfoCode("sudo chown -R ism:ism /mnt/ism/var/log/ism")
        showInfoCode("sudo chown -R ism:ism /mnt/ism/tmp/ism")

        showInfo("After this, mount all necessary virtual kernel filesystems by the following commands:")
        showInfoCode("sudo mount --types proc /proc /mnt/ism/proc")
        showInfoCode("sudo mount --rbind /sys /mnt/ism/sys")
        showInfoCode("sudo mount --rbind /dev /mnt/ism/dev")
        showInfoCode("sudo mount --bind /run /mnt/ism/run")

        showInfo("Then copy the network configuration to the new system:")
        showInfoCode("sudo cp /etc/resolv.conf /mnt/ism/etc/resolv.conf")

        showInfo("Finally, you can enable the secure mode and continue your installation.")
        showInfoCode("sudo ism settings -esm")
    end

end
