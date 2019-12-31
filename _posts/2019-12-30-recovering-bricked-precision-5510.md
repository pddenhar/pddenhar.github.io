---
layout: post
title: Recovering a bricked Dell Precision 5510
---
My Dell Precision 5510 (more or less an enterprise XPS 15 9550) recently updated itself to BIOS version 1.12.0. Apparently this BIOS version has a known issue where pressing F8 during boot will cause a no-POST, no display condition which effectively bricks the laptop.

When the power button was pressed, my laptop would do nothing other than light the power LED. No fans, so image on screen at all.

I've seen many other people with this issue on the web, so this isn't an isolated problem:
* <https://www.reddit.com/r/Dell/comments/8vixl6/cannot_recover_a_possibly_bricked_xps_15_9550/>
* <https://www.reddit.com/r/Dell/comments/87n2r5/anyone_else_have_bios_updates_bricking_laptops/>
* <https://www.google.com/search?q=precision+5510+bricked+no+post+site:www.reddit.com>

Oddly enough, holding D when pressing the power button would bring up the display diagnostics which worked fine. The display would cycle through the colors and then shut down.

The way I finally fixed my system is as follows:

* Disassemble the rear panel of the laptop and remove the battery.
* Remove the screws holding the motherboard in and disconnect the two ribbon cables connecting the touch pad. 
* Tilt the motherboard up towards the fans and unplug the CMOS battery. Hold the power button for 15 seconds.
* Reassemble the laptop.
* Download version 1.7.0 of the BIOS and copy it to a FAT32 formatted flash drive. Rename the file to "BIOS_IMG.rcv"
* Plug the flash drive into the top left USB port next to the power jack on the laptop.
* Hold ctrl and esc and plug the powe cable into the laptop. It will boot and perform a BIOS recovery.
* Let the laptop reboot itself. If you were successful, a screen should show up saying that the RTC time is invalid.

Oddly enough, the BIOS version never changed from version 1.12.0 even though I used the file for 1.7.0. Nonetheless, 
this was the only way I managed to even get any sign of life out of my laptop. I have seen many people with this problem on the web, so I hope my experience helps someone else recover their (very expensive) laptop.

Since this issue seems to also apply to people with the XPS 15 9550 and other laptops, there's a chance that the above steps will also help them. 
