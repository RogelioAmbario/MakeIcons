README MAKEICONS V3.2

Hello, Developer:

MakeIcons.bat was made to simply take a picture, make copies of it in different sizes and place a copy in specific folders with a specific file name.
Most common case is to make icons for different resolutions.
Second most common case is when making push notification icons.


The steps are simple:
	1.- Place and rename your icon with rounded corners to "icon.png" (This filename and extension are set as default, may be edited in configuration file "configs.txt").
	2.- Edit configuration file "configs.txt" to set your list of needed sizes. (You need at least one item, could be number or a combined number separated with an "x" like "100x75" ).
	3.- Edit configuration file "configs.txt" to set your destination folders. (Under the section "# ==== Copy Icons ====", you need specify the size of icon you need to copy, the destination folder and the final name the icon needs)
		(You may use direct paths or batch variables, you may even create your own batch variables to be used).
	4.- Save your changes in configuration file "configs.txt".
	5.- Run MakeIcons.bat

This should create the icons in the same folder that MakeIcons.bat is stored, copy, rename, and lastly erase all of them.

The standard output extension should always be PNG files for icons.

IMPORTANT: Remember that for icons the corners should be rounded, is your icons is square, you may follow these steps to round its corners.

How to round icon corners:
	1.- Open iOS icon with square corners, with GIMP 2.8 (the biggest with the better quality).
	2.- Then in the menus select Filters -> Decor -> Round Corners.
	3.1.- In case "Round Corners" is inactive, Select the icon layer and right click on it,
		  in the context menu, select "Remove alpha channel". Then try again Step 4.
	4.- Edge Radius: 10. (Gameloft says the standard is 5% radius)
	4.1.- NO drop shadow.
	4.2.- NO add background.
	4.3.- NO work on copy.
	5.- Export as "icon.png".

==================================================================================================================================================
NOTE: For more info about nconvert.exe, under command promt type "nconvert --help > help.txt" and read "help.txt"
MakeIcons Developer: Rogelio.Ambario@gmail.com
Github Repository: https://github.com/RogelioAmbario/MakeIcons.git
==================================================================================================================================================



==================================================================================================================================================
ADVANCED MODE: The following part is only to be used in case you need to edit beyond the normal use.
==================================================================================================================================================
If you modify MakeIcons.bat under the section "initAuto:" You may change the following variables:

input_FileName: To change the way the input file name is constructed.

output_Ext: You can change here what output extension you need the files to be converted. Default value is PNG.

Available Extensions for output_Ext: alias, arcib, biorad, bmp, cin, cvs, dcx, dds, degas, dkb, dpx, emf, fits, gif, gpat, grob, hru, ico, iff, jif, jpeg, jpg, jxr, kro, miff, mtv, ngg, nlm, nol, otb, pabx, palm, pbm, pcl, pcx, pdf, pgm, png, pnm, ppm, prc, ps, psd, psion3, psion5, grt, rad, raw, rawe, ray, rla, sct, soft, tdi, tga, ti, tiff, uyvy, uyvyi, vista, vivid, wbmp, wrl, xbm, xpm. 


You can decide if just want to make icons leaving them in this folder, copy to destination and/or delete icons from this folder.

makeIcons, copyIcons, deleteIcons:  By turning on (1) or off (0) these variables you control the parts of the whole process.


