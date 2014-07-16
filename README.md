## e4p_pprocessor<br />Eyesis 4Pi GNU Parallel Processor

Eyesis 4Pi GNU Parallel Processor.

### Requirements
1. GNU parallel must be installed on all Workers (nodes) including the host machine that runs processing scripts, Install it with **sudo apt-get install parallel**
2. Enblend must be installed on all Workers (nodes), Install it with **sudo apt-get install enblend**
3. Fiji with Elphel plugins must be installed, ...

### Documentation
#### gen_scripts/gen_fijilist.sh (ImageJ processing joblist generator)
    gen_fijilist.sh <eyesis_correction_xml> <source_dir> [ <results_dir>  <output_file> ]
#### gen_scripts/gen_stitchlist.sh (Stitching joblist generator)
    gen_stitchlist.sh <Source directory> <Destination Directory> <Black point> <White point> <Quality>

#### tools/runchecker (Panorama timestamps checker)
    tools/runchecker -i <jp4 folder> [-t <trash folder> -v <Validate all trashs> -w <Write file paths to file> -l <Write stdout to a log file>]

### Initial setup

#### 1. Workers (nodes) setup
    mkdir ~/.parallel
    echo "user@host1,user@host2" > ~/.parallel/sshloginfile

#### 2. SSH host keys registration
    tools/sshcopykeys
    
### Usage
#### Stitching
    gen_script/gen_stitchlist.sh /data/footage/test/imagej_processed/ /data/footage/test/results/ 0 100 98 > stitch.sh
    ./stitch.sh
#### ImageJ processing
    gen_script/gen_fijilist.sh /data/footage/test/corr.xml /data/footage/test/0 /data/footage/test/imagej_processed  > fiji.sh
    ./fiji.sh
### Copyright

Copyright (c) 2014 FOXEL SA - [http://foxel.ch](http://foxel.ch)<br />
This program is part of the FOXEL project <[http://foxel.ch](http://foxel.ch)>.

Please read the [COPYRIGHT.md](COPYRIGHT.md) file for more information.


### License

This program is licensed under the terms of the
[GNU Affero General Public License v3](http://www.gnu.org/licenses/agpl.html)
(GNU AGPL), with two additional terms. The content is licensed under the terms
of the
[Creative Commons Attribution-ShareAlike 4.0 International](http://creativecommons.org/licenses/by-sa/4.0/)
(CC BY-SA) license.

Please read <[http://foxel.ch/license](http://foxel.ch/license)> for more
information.
