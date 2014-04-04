nweather-upload
===============

This script can be used to upload a WS-2300 (or compatible) weather station's
data acquired with fetch2300. I made a [Wordpress plugin](https://github.com/nonoo/nweather-wordpress-plugin)
to show the collected data on a Wordpress page.

#### Usage

Copy *config-example* to *config* and edit it. You can run *upload2300-test.sh*
to post the example data which can be found in the file *fetch2300-example*.

See *upload2300.sh* source for the values which can be posted.

You'll need [nlogrotate](https://github.com/nonoo/nlogrotate).
