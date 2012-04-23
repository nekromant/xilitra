define description
A Xilitra limited port to run at WM8650 tablets
endef


#This sets the policy of package autosplitting
#If set to other then y - this has no effect whatsoever
#Apart from the binaries, you can do the following with the rest of the data:
#drop (just remove it)
#keep (it stays along with the package)
#split (move to a new package)

PKG_DEV=split
PKG_DOC=drop
PKG_DBG=split

CROSS_COMPILE=arm-xilitra-linux-uclibcgnueabi
STAGING=$(WORKDIR)/staging
#We need to set it to OPT to make our system run alongside android
#The actual prefix for programs will be $TC_PREFIX/$PREFIX. This is required, 
#so that we can make a working in /opt and do not require any chroot
EXTRA_PREFIX=/opt
