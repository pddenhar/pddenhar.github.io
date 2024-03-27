---
layout: post
title: Diagnosing a light, random misfire on a Jeep XJ 4.0l Engine
custom_css: syntax.css
---
I recently bought a 2000 Jeep Cherokee (XJ) with the 4.0l inline-6 engine. 
It had a light misfire at idle and would blink the check engine light under heavy acceleration. 
Here is the procedure that I used to diagnose and solve the problem.

#### Symptoms
When scanned with OBDII, the ECU reported P0300 (Random misfire) and individual misfire codes for each cylinder (P0301 - P0306). It shuddered slightly at idle 
and got bad fuel economy on the highway. 

#### Diagnosis
These are the steps that I followed to track down this issue. They are not necessarily perfect, but I hope they can help anyone else with similar symptoms on their Jeep.

##### Spark Plugs

When diagnosing a misfire, you should check and fix the obvious problems first. In my case, the obvious things were spark plugs and fuel. Bad spark plugs can easily cause misfires,
and in this case the Jeep had 275,000 miles and spark plugs of unknown age. I pulled all six spark plugs, and all had a large gap of more than 0.040". 
Replacing all six with fresh [NGK ZFR5N V-Power](https://amzn.to/3aI0TsT) copper plugs was in order. Unfortunately, although this smoothed out the idle, it did not solve the misfire entirely.

##### Fuel Pressure
A clogged fuel filter could cause fuel rail pressure drop under load, which could explain the misfire on the highway. I connected my fuel pressure gauge to the test port on the fuel rail
and checked fuel pressure, both at idle and under load. The pressure stayed steady at 48 psi, which indicated that the fuel pump or filter were not the culprit. 

##### Ignition
With the obvious problems ruled out, it was time to start more in depth diagnosis. The 99-01 XJs have a coil-on-plug ignition pack for all six cylinders instead of a distributor and 
individual plug wires. Aging coils could cause a misfire, so I pulled the coil rail and tested the resistance of the primary side of the coils.

The three coils are controlled by a four pin connector, with one shared 12V+ pin and three switched grounds. You can check the resistance of the primary coils by measuring resistance from
the +12V pin to the ground pin for each of the three coils. In the XJ's case, pin 2 is 12V+ and the other three are the individual grounds.

My measured resistances for the primary side of all three coils was ~1.49 ohms. This is a bit high compared to the factory service manual spec of 0.71 - 0.88 ohms, 
but the difference could be due to my multimeter. To be on the safe side, I measured a brand new coil from the parts store and got the exact same reading, indicating that my coil was likely
not the culprit.

To be safe, I tried the new coil on the engine, but unsurprisingly it did not change the misfire. 

##### Compression
The 4.0l is known for cracked and warped heads that cause cylinder to cylinder head gasket failures. There has also been a TSB on the engine for 
valves getting wedged open due to carbon buildup, which would cause no compression on the effected cylinder.
To check if this was the case, I measured compression on all six cylinders. 
A low reading of two cylinders side-by-side would be a great hint that I had a head gasket problem.

My measurements were as follows:
1. 125
2. 130
3. 140
4. 125
5. 135
6. 135

For a 275,000 mile engine these numbers look pretty good. The specification is 120-150 psi with no more than 30 psi variance between cylinders, so this engine passes.
It's unlikely that low compression or bad valve seats are the culprit. 

##### Fuel Injectors
At this point, it was time to really dig in. Uneven fueling could cause the ECU to register a misfire, so it was time to pull and inspect the injectors.

Looking at the six injectors, it seemed possible that I had found thed cause. Two of the six were a different brand and serial number, and two more had large cracks in their plastic bodies.

I ordered six Bosch EV6 injectors on eBay
to replace them. For now, I'm waiting for them to arrive to continue this saga.
