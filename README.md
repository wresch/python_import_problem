Objectives
------------------------------------------------------------------------

1. Measure scaling of python startup and import speed with
   increasing numbers of concurrent python interpreters
2. Compare scaling of a standard python installation with
   an identical containerized installation

Background
------------------------------------------------------------------------

Other HPC sites have reported about the "python import problem" that 
results from many concurrent python jobs starting up and importing 
libraries. Each such interpreter will "touch" many (thousands) of files
to find and import base libraries and whatever libraries are imported 
explicitly. This strains the filesytem (lots of metadata ops) and 
results in slower startup speeds.  The same likely holds true for other
interpreted languages (R, perl, ...).

Method
------------------------------------------------------------------------

I started 1, 2, 4, 8, or 16 concurrent python interpreters on 10, 20,
40, 80, 160, and 320 nodes at the same time. Each imported 8 commonly
used libraries (numpy, scipy, pandas, sqlite3, bipython, matplotlib,
seaborn, bokeh). I measured total time for running those tests as well
as the individual run times of each of the "gaggles" of 1, 2, 4, ...
concurrent interpreters on one node.

This either used the python/2.7 standard conda python (py_conda) or an
identical conda environment wraped into a singularity container
(py_container) of ~3.3GB. The conda environment is described in 
`py2.7.yml` and the singularity container in `miniconda.def`.

Results
------------------------------------------------------------------------

First, the overall time it took to start n * N python interpreters each
importing the 8 modules listed above. Note the log-log scale:

![overall_time]("overall_time_loglog.png" "Overall runtimes")

The singularity container scaled better in these experiments than the standard
python installation.

And here are the individual runtimes for each gaggle:

![individual_time]("individual_time_loglog.png" "Individual runtimes")

The grey points are the full dataset shown as background for easier
comparison. The colored points are the subsets (i.e. standard conda python
environment (py_conda) vs. singularity container containing conda python
(py_container)).
