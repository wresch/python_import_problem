Objectives
------------------------------------------------------------------------

1. Measure scaling of python startup and import speed with
   increasing numbers of concurrent python interpreters
2. Compare scaling of a standard python installation with
   an identical containerized installation 
   ( [Singularity](http://singularity.lbl.gov/) ).

Background
------------------------------------------------------------------------

There have been reports about the "python import problem" that results from
many concurrent python jobs starting up and importing libraries. Each such
interpreter will stat and/or read many files to find and import base libraries
and whatever libraries are imported explicitly. This strains the filesytem
(lots of metadata ops) and results in slower startup speeds as the number of
concurrent jobs increase.  The same may also hold true for other interpreted
languages. A number of different solustions have been proposed, including
containerization, static builds, or schemes to amortize the cost of loading
libraries across multiple interpreters. Here I compare a plain python
environment to the same environment packaged into a
[Singularity](http://singularity.lbl.gov/) container.

Method
------------------------------------------------------------------------

I started 1, 2, 4, 8, or 16 concurrent python interpreters on 10, 20,
40, 80, 160, and 320 compute nodes at the same time. Each imported 8 commonly
used libraries (numpy, scipy, pandas, sqlite3, bipython, matplotlib,
seaborn, bokeh). I measured total time for running those tests as well
as the individual run times of each of the "gaggles" of 1, 2, 4, ...
concurrent interpreters on one node.

This either used the python/2.7 standard conda python (py_conda) or an
identical conda environment wraped into a Singularity container (py_container)
of ~3.3GB. Both were located on the same shared (NFS) filesystem. The conda
environment is described in `py2.7.yml` and the Singularity container in
`miniconda.def`.

Results
------------------------------------------------------------------------

First, the overall time it took to start n * N python interpreters each
importing the 8 modules listed above. Note the log-log scale:

![overall_time](overall_time_loglog.png?raw=true "Overall runtimes")

The singularity container scaled better in these experiments than the standard
python installation.

And here are the individual runtimes for each gaggle:

![individual_time](individual_time_loglog.png?raw=true "Individual runtimes")

The grey points are the full dataset shown as background for easier
comparison. The colored points are the subsets (i.e. standard conda python
environment (py_conda) vs. singularity container containing conda python
(py_container)).
