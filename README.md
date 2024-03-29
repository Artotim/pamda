# Pamda
Visit our [home page](http://biodados.icb.ufmg.br/pamda/)!

<p align="center" width="100%">
    <a href="http://biodados.icb.ufmg.br/pamda">
        <img alt="Pamda logo" src="http://biodados.icb.ufmg.br/pamda/assets/images/pamda_logo.png"  width="150" height="150"/>  
    </a>
</p> 

Pamda was created to facilitate the study and analysis of molecular dynamics without the need for programming. It has the advantage of being able to analyze very large dynamics, which would not fit in memory for a traditional analysis.

Pamda is contained within a Docker container, and mostly uses VMD to perform the analysis. Both are not provided by us and must be obtained and installed separately. 

With Pamda you will be able to perform analysis of **RMS**, **contacts between chains**, **distances**, **SASA**, **BSA** and **energies**. Currently it only supports Gromacs and NAMD trajectories. 


## Installation
This program requires Docker and VMD installed to run. After you installed the dependencies you can run it with the following commands:

```shell
wget http://biodados.icb.ufmg.br/pamda/pamda
chmod -x pamda
./pamda -h
```

A fully installation guide and **documentation** can be found on our home page [here](http://biodados.icb.ufmg.br/pamda/). 


## Contributing
You can help by fixing bugs, implementing new features, improving analysis, keeping docs clean and up to date, in short, any contribution is always welcome.

We use GitHub, so all code changes happen through pull requests.

1. Fork the repository and create your branch from master.
1. If you've changed the functionality, also issue a documentation update.
3. Issue the pull request! 🎉


## Disclaimer

This product comes with no warranty whatsoever.  

This product is not an official VMD release or has any affiliation to it.  

This software includes code developed by the Theoretical and Computational Biophysics Group in the Beckman Institute for Advanced Science and Technology at the University of Illinois at Urbana-Champaign.
 
Third party licenses not obtained by the user are provided with its software. 
