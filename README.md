ClarityLIMS configslicer helper
===============================

This script is a quick way to initiate multiple import or export workflow commands by running just 1 command. The workflows and their corresponding manifest / configuration file name are set in a .cfg file.

The export will initiate 2 commands:
1. custom manifest generation .txt
2. export into configuration file .xml

To run:
-------

sh configslicer_help.sg ./<config_file> <export|import> ./<file_directory>

The config file
---------------

<file_name>="<workflow name in ClarityLIMS>"

```
  wf_receive="FFPE Receiving v1.0.0"
  wf_quantification="RNA Quantification v1.0.0"
```

