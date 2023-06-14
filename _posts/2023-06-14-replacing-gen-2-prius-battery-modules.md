---
layout: post
title: Replacing Individual Cells in a Gen 2 Prius Battery
custom_css: syntax.css
---
I purchased a 2006 XW20 Prius (Gen 2) from a trucking company that had used it as a shuttle vehicle. 
The red triangle warning light was on with codes for a bad hybrid battery. To save money, I decided to try 
repairing the battery using individual cells purchased from Ebay instead of immediately paying for a whole refurbished pack. 

|  Supplies               | Link                    |
|-------------------------|-------------------------|
| Trim Clip Removal Tool  | https://amzn.to/2GP5lpl |
| Replacement Trim Clips  | https://amzn.to/2GWj7b2 |
| Turnigy Battery Charger |                         |
| Toyota WS ATF           | https://amzn.to/2LqJzxw |

Removing the Battery
--------------------

[ChrisFix](https://www.youtube.com/watch?v=Q3RCdrh666w) has an excellent video on YouTube detailing the removal of the hybrid battery. I followed that step by step
(seriously, buy the [trim tool](https://amzn.to/2GP5lpl) and some replacement [trim clips](https://amzn.to/2GWj7b2) from Amazon! It makes the job so much easier) to remove the rear interior, seats, and hybrid battery. 

I also purchased some [Toyota WS ATF](https://amzn.to/2LqJzxw) while I was at it, figuring that I might as well refresh the transaxle fluid while I was working on the hybrid system.

Once I had the battery out of the car and on my bench I measured the voltage of each of the 28 cell packs. All of them except for cell 11 and cell 21 were within a few hundredths of a volt of 7.75v. Cells 11 and 21 were both close to 6.45v.

It's easy enough to find replacement cells on eBay and insert them into the pack to replace the low cells, but after doing so it's critical that you **balance the battery pack**.

Balancing the Cells
-------------------

I can save you time right off the bat with this TLDR: Don't bother individually charging battery modules. There are 28 of them and it can take weeks with a single charger.

To save time, purchase a high voltage, constant (low) current DC power supply that can top-balance the whole pack at once. NiMh cells have the desirable property (different than lithium-ion!) that they can be overcharged without damage. This allows you to simply overcharge the whole pack at a **low** current which will cause the higher voltage cells to dissipate the excess charge as heat, while the lower voltage cells catch up. Once all cells reach approximately [1.41v](https://www.powerstream.com/NiMH.htm) they will begin balancing. You will eventually be left with a top-balanced pack, with all cells fully charged.

It's important that you charge at a very low current. The Gen 2 Prius pack tops out around 270V, and if you tried charging it at 1A, that would mean approximately 270W of heat energy being dissipated in the pack once almost all the cells are topped up and you're waiting for one or two stragglers to finish charging.

To safely top balance the pack, I purchased a Meanwell constant current LED driver rated for 350mA (approximately C/20 for the 6.5Ah Prius pack). This would result in a guaranteed full pack charge in 20 hours, even if all cells were empty. In my case, the every module reached balancing voltage after about 8 hours, so I left it balancing for another 4 hours. After 14 hours of total charging, the pack was top-balanced.

Note that the Prius battery disconnect plug actually splits the NiMh pack in half when disconnected, so you will not be able to charge all 28 modules at once using this method. I charged my pack in two groups of 14 modules, which is better from a safety perspective since you don't need to interact with the full 270V output of the pack. For half the pack, you should expect to see voltages from about 86V (fully discharged) to 126V (all cells at 1.5V, fully charged).

Reinstalling the Pack
---------------------

One final note for re-installation: I wasn't sure how the Prius would handle a fully charged pack, since it generally expects charge state to be less than ~80% or so (to preserve the life of the cells). With this in mind, I decided to slightly discharge the pack before installing it. I connected a 40W light bulb across half of the pack at a time and discharged each half for an hour, which brought cell voltage down from the maximum value.

Otherwise, installation is the reverse of removal😉

