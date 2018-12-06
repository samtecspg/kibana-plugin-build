# SPG Kibana plugin dev/build images

The goal of this repo/dockerhub is to provide a series of docker containers, matched to the releases of Kibana/ES that are being supported, such that SPG can build/dev Kibana plugins across those ES releases. These instructions are for plugins build using the [Kibana Plugin Generator](https://github.com/elastic/kibana/tree/master/packages/kbn-plugin-generator).

Follow the below instructions to build your Kibana plugin:

1. `./build-by-version.sh 6.1.1` - to build a local kibana build image (ends up named `samtecspg/kibana-plugin-dev:6.1.1`)
2. Go to the `kibana-extra` folder where your plugin resides. Do a ``docker run --rm -it -v `pwd`:/kibana-extra/ samtecspg/kibana-plugin-dev:6.1.1 bash`` (In our project [Conveyor](https://github.com/samtecspg/conveyor), that place is *[project-root]/kibana-extra*)
3. (Working in the same window that you ran the `docker run` - which now is at the prompt of the running container) Jump over to the plugin directory `cd kibana-extra/your-plugin-name`
4. *IMPORTANT* Edit the `package.json` and set the version equal to what you did the `build-by-version` on (so for what was in set one, the version would be "6.1.1") -- (because of the previous steps, this file should be mounted via the `` `pwd`:/kibana-extra/your-plugin-name`` mount so you can edit it inside or outside the container, what ever is easier for you)
5. (for our project) do the build (as explained in https://github.com/samtecspg/conveyor/blob/master/development.md#build )
   1. `yarn kbn bootstrap`
   2. `yarn build` 
6. `exit` or ctrl-d out of the container
7. look in the `build` directory, and you should see the build zip file
 
NOTE: If you run the kibana container to run without a command (I.E. the `bash` part above), it is setup to do nothing.  ... or more to the point, `sleep`. The sleep is for 1500 seconds, so if run it that way, you have 25 minutes to do whatevery it is you want to do - after that it will automaticly exit (and remove itself if you gave the `--rm` option)

---

