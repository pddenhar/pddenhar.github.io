---
layout: post
title: Creating Udev Rules for Generating Persistent Device Names
custom_css: syntax.css
---
The poorly documented and understood udev system on Ubuntu now generates persistent device names for network hardware, which is a step up from the old system where device names would be reassigned at boot and hardware changes could make assosciating a name with a physical insterface very frustrating. I wanted to take this a step further and generate meaningful custom names for different classes of hardware. 

Specifically, much of the work I do involves USB 4G modems that appear as an emulated ethernet device. I want specific modems to recieve device names other than eth(x) to refect the networks they run on and the hardware they use. For example, I want Pantech UML 295s to appear as vz(x) instead of eth(x). Previously, I had been doing this the manual way that gets recommended any time this question is asked on the internet and modifying the `/etc/udev/rules.d/70-persistent-net.rules` file to change the name of a device after it had been plugged in. For example:

{% highlight bash %}
# USB device 0x10a9:0x6064 (cdc_ether)
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="d0:58:85:6d:05:0b", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="vz0"
{% endhighlight %}

This would change the name of the card with this specific MAC address to be vz0. This method was non ideal though, because it required manual intervention each time a card was plugged in. I wanted to use udev to fully automate the process of generating better names for cards. 

Rule generation is handled by the file `/lib/udev/rules.d/75-persistent-net-generator.rules` which invokes the shell script `/lib/udev/write_net_rules` to actually create the persistent rules file (this is all on Ubuntu and may be slightly different on other distributions).

The `write_net_rules` script operates based on the values the environment variables that are set before execution and helpfully includes the variable `INTERFACE_NAME` which allows "external tools" (whatever that means) to choose a name for the interface. This actually means that we won't even need to modify the `75-persistent-net-generator.rules` file at all and can simply create our own file that will execute before it in the udev rule chain to set the `INTERFACE_NAME` variable. To do this, I created `/etc/udev/rules.d/71-cell-card-naming.rules` which looks like this:

{% highlight bash %}
ENV{ID_VENDOR_ID}=="216f", ENV{ID_MODEL_ID}=="0047", ENV{INTERFACE_NAME}="cio0"

ENV{ID_VENDOR_ID}=="10a9", ENV{ID_MODEL_ID}=="6064", ENV{INTERFACE_NAME}="vz0"
{% endhighlight %}

The file contains two rules which provide interface names for different classes of 4G card. The match information at the beginning of each command was found using the udevadm command to print info about the device. To print all information on the Pantech card the command looked like this: `udevadm info -a --path /sys/class/net/eth2 | less`. It prints a lot of information, but the important stuff is this:

{% highlight text %}
P: /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/2-1.7:1.0/net/eth2
E: DEVPATH=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/2-1.7:1.0/net/eth2
E: ID_BUS=usb
E: ID_MODEL=PANTECH_UML295
E: ID_MODEL_ENC=PANTECH\x20UML295
E: ID_MODEL_ID=6064
E: ID_NET_NAME_MAC=enxd057856d050b
E: ID_NET_NAME_PATH=enp0s29u1u7
E: ID_OUI_FROM_DATABASE=Pantech Co., Ltd.
E: ID_REVISION=0228
E: ID_SERIAL=Pantech__Incorporated_PANTECH_UML295_UML295594515508
E: ID_SERIAL_SHORT=UML295594515508
E: ID_TYPE=generic
E: ID_USB_CLASS_FROM_DATABASE=Communications
E: ID_USB_DRIVER=cdc_ether
E: ID_USB_INTERFACES=:020600:0a0000:030000:020201:
E: ID_USB_INTERFACE_NUM=00
E: ID_VENDOR=Pantech__Incorporated
E: ID_VENDOR_ENC=Pantech\x2c\x20Incorporated
E: ID_VENDOR_FROM_DATABASE=SK Teletech Co., Ltd
E: ID_VENDOR_ID=10a9
E: IFINDEX=31
E: INTERFACE=eth2
E: SUBSYSTEM=net
E: USEC_INITIALIZED=436817887
{% endhighlight %}

Those variables can be matched on using the ENV{} syntax, for my purposes the `ID_MODEL_ID` and `ID_VENDOR_ID` variables were plenty to create the `71-cell-card-naming.rules` file.

There is one last piece of the puzzle which is more messy and less fun to deal with. The `write_net_rules` script has poorly thought out control flow for the section that handles custom names, which means that it doesn't check for duplicate devices when creating custom ones and as a result you will end up with a file full of devices named vz0 if you don't fix it. This section specifically needed to be changed:

{% highlight bash %}
basename=${INTERFACE%%[0-9]*}
match="$match, KERNEL==\"$basename*\""

if [ "$INTERFACE_NAME" ]; then
    # external tools may request a custom name
    COMMENT="$COMMENT (custom name provided by external tool)"
    if [ "$INTERFACE_NAME" != "$INTERFACE" ]; then
        INTERFACE=$INTERFACE_NAME;
        echo "INTERFACE_NEW=$INTERFACE"
    fi
else
    # if a rule using the current name already exists, find a new name
    if interface_name_taken; then
        INTERFACE="$basename$(find_next_available "$basename[0-9]*")"
        # prevent INTERFACE from being "eth" instead of "eth0"
        [ "$INTERFACE" = "${INTERFACE%%[ \[\]0-9]*}" ] && INTERFACE=${INTERFACE}0
        echo "INTERFACE_NEW=$INTERFACE"
    fi
fi

{% endhighlight %}

I reworked the control flow so that the check for duplicate interface names would not get skipped if custom names were in use. Simply replace the above lines with the code shown here:

{% highlight bash %}
basename=${INTERFACE%%[0-9]*}
match="$match, KERNEL==\"$basename*\""

if [ "$INTERFACE_NAME" ]; then
    # external tools may request a custom name
    COMMENT="$COMMENT (custom name provided by external tool)"
    if [ "$INTERFACE_NAME" != "$INTERFACE" ]; then
        INTERFACE=$INTERFACE_NAME;
        echo "INTERFACE_NEW=$INTERFACE"
    fi
fi

basename=${INTERFACE%%[0-9]*}

# if a rule using the current name already exists, find a new name
if interface_name_taken; then
    INTERFACE="$basename$(find_next_available "$basename[0-9]*")"
    # prevent INTERFACE from being "eth" instead of "eth0"
    [ "$INTERFACE" = "${INTERFACE%%[ \[\]0-9]*}" ] && INTERFACE=${INTERFACE}0
    echo "INTERFACE_NEW=$INTERFACE"
fi
{% endhighlight %}

With this change you can get properly increasing persistent network names for every new piece of hardware you plug in.