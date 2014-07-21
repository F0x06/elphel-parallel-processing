## elphel-parallel-processing<br />Elphel camera array images post processing using GNU parallel

Elphel camera array images post processing using GNU parallel.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Requirements](#requirements)
- [Workers configuration](#workers-configuration)
- [Usage](#usage)
  - [Post-processing](#post-processing)
  - [Stitching](#stitching)
  - [Timestamps checker](#timestamps-checker)
  - [Node controller](#node-controller)
  - [SSH keys copier](#ssh-keys-copier)
- [Example usage scenario (post_processing)](#example-usage-scenario-post_processing)
- [Example usage scenario (stitching)](#example-usage-scenario-stitching)
- [Copyright](#copyright)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Requirements

1. GNU parallel must be installed on all Workers (nodes) including the host machine that runs processing scripts, Install it with **sudo apt-get install parallel**
2. Enblend must be installed on all Workers (nodes), Install it with **sudo apt-get install enblend**
3. Fiji with Elphel plugins
    1. Fiji: http://fiji.sc/Fiji
    2. Elphel ImageJ plugins: https://github.com/FoxelSA/imagej-elphel

### Workers configuration

To use remote machines for processing, the login must not require a password or you can add your SSH key to remote hosts, and the required directories must be accessible from every machine, you can use a network folder mounted at the same place.

Our scripts try to read the remote host list from ~/.parallel/sshloginfile

        mkdir ~/.parallel
        echo "user@host1" >> ~/.parallel/sshloginfile
        echo "user@host2" >> ~/.parallel/sshloginfile
        
 But you can specify them with other GNU parallel options in the PARALLEL environment variable or with other GNU parallel options as arguments for the generated scripts:

        PARALLEL="-S user@host,user@host2,..."

and/or

        generated_script -S user@host,user@host2,...

See the GNU parallel manual page for -S option details and more.

If you want to register your SSH key to the remote hosts, you can simply do it with the following command

        tools/sshcopykeys

### Usage
#### Post-processing
      
      Usage: bin/post_processing <eyesis_correction_xml> <source_dir> [ <results_dir>  <output_script> ]

- When no output file is specified, parallel is run immediately.
- You can run the generated file (again), arguments are passed to GNU parallel (or you can use the PARALLEL environment variable). 
- Paths for corrxml can be specified as environment variables.
- By default it generate one xml (job) per panorama (because CHANNEL=9)

#### Stitching

      Usage: bin/stitching <Source directory> <Destination Directory> [ <Black point> <White point> <Quality> <Output_script> ]
    
- When no output file is specified, parallel is run immediately
- You can run the generated file (again), arguments are passed to GNU parallel (or you can use the PARALLEL environment variable). 

#### Timestamps checker

      Usage: tools/runchecker -i <jp4 folder> [-t <trash folder> -v <Validate all trashs> -w <Write file paths to file> -l <Write stdout to a log file>]

#### Node controller

      Usage: tools/nodecontrol [-b <Command to broadcast>, Broadcast command to all nodes | -p, Ping SSH hosts, -S <user@domain1,user@domain2>, SSH hosts list]
      
#### SSH keys copier
      Usage: tools/sshcopykeys [-S <user@domain1,user@domain2>, SSH hosts list]

- When no arguments is specified, sshcopykeys reads SSH keys from ~/.parallel/sshloginfile file

### Example usage scenario (post_processing)

- Register nodes (Only once, until you add more nodes)

        echo "pr@192.168.1.151" >> ~/.parallel/sshloginfile
        echo "pr@192.168.1.152" >> ~/.parallel/sshloginfile

- Copy SSH keys (Only once, until you add more nodes)

        tools/sshcopykeys

- Mount required folders

        tools/nodecontrol -b "sudo mkdir -p /data/footage"
        tools/nodecontrol -b "sudo mount -t nfs 192.168.1.161:/volume/footage /data/footage"
        
        tools/nodecontrol -b "sudo mkdir -p /data/calibration-files"
        tools/nodecontrol -b "sudo mount -t nfs 192.168.1.161:/volume/calibration-files /data/calibration-files -o ro"

- Configure ImageJ paths

        export equirectangularDirectory="/data/calibration-files/Eyesis4pi-06d/calibration/maps"
        export sensorDirectory="/data/calibration-files/Eyesis4pi-06d/calibration/sensors"
        export sharpKernelDirectory="/data/calibration-files/Eyesis4pi-06d/calibration/kernels/sharp"
        export smoothKernelDirectory="/data/calibration-files/Eyesis4pi-06d/calibration/kernels/smooth"
      
- Generate post_processing script

        bin/post_processing /data/footage/data1/autoconfig_227537_946535.corr-xml /data/footage/data1/0 /data/footage/data1/imagej_processed post_process1.sh
      
- Start the processing

        ./post_process1.sh
        
### Example usage scenario (stitching)

- Register nodes (Only once, until you add more nodes)

        echo "pr@192.168.1.151" >> ~/.parallel/sshloginfile
        echo "pr@192.168.1.152" >> ~/.parallel/sshloginfile

- Copy SSH keys (Only once, until you add more nodes)

        tools/sshcopykeys

- Mount required folders

        tools/nodecontrol -b "sudo mkdir -p /data/footage"
        tools/nodecontrol -b "sudo mount -t nfs 192.168.1.161:/volume/footage /data/footage"
        

- Generate stitching script

        bin/stitching /data/footage/data1/imagej_processed /data/footage/data1/results 0 100 98 stitch1.sh
      
- Start the stitching

        ./stitch1.sh
      
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
