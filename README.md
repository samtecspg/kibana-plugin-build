# SPG Kibana plugin dev/build images

The goal of this repo/dockerhub is to provide a series of docker containers, matched to the releases of Kibana/ES that are being supported, such that SPG can build/dev Kibana plugins across those ES releases.

Day two, this was used by:

1. `./build-by-version.sh 6.1.1` - to build a local kibana build image (ends up named `samtecspg/kibana-plugin-dev:6.1.1`)
2. Go whereever you have the code you want to build and do a ``docker run --rm -it -v `pwd`:/kibana/plugin samtecspg/kibana-plugin-dev:6.1.1 bash`` (In our project, that place is *[project-root]/plugin*)
3. (Working in the same window that you ran the `docker run` - which now is at the prompt of the running container) Jump over to the plugin directory `cd plugin`
4. *IMPORTANT* Edit the `package.json` and set the version equal to what you did the `build-by-version` on (so for what was in set one, the version would be "6.1.1") -- (because of the previous steps, this file should be mounted via the `` `pwd`:/kibana/plugin`` mount so you can edit it inside or outside the container, what ever is easier for you)
5. (for our project) do the build (as explained in https://github.com/samtecspg/conveyor/blob/master/development.md#build )
   1. `yarn install`
   2. `yarn build` 
6. `exit` or ctrl-d out of the container
7. look in the `build` directory, and you should see the 
 
NOTE: If you run the kibana container to run without a command (I.E. the `bash` part above), it is setup to do nothing.  ... or more to the point, `sleep`. The sleep is for 1500 seconds, so if run it that way, you have 25 minutes to do whatevery it is you want to do - after that it will automaticly exit (and remove itself if you gave the `--rm` option)

---

As of day one, what its become:

- `docker-compose.yml` that will startup ES and **build** a kibana (with the beginning of the dev stuff) from the version that it set via the `ELASTIC_VERSION` env var (the kibana image that gets built will be tagged with the `ELASTIC_VERSION`)
  - WARNING: (so far) I haven't been able to automate the pull of the node version that a given `ELASTIC_VERSION` wants, so you must set `KIBANA_NODE_VERSION` too - and in the build it will check, and error out if it doesn't match the .node-version in the kibana tag that matches `ELASTIC_VERSION``
- 'Dockerfile' that takes env vars to pick the node image version its based off of and which tag of kibana to pull. (see warning above)
  - Given a current lack of ideas on what to have the kibana image run (given you may want to change/restart kibana) its running a `sleep 1500` *I know this is a bad idea...*

I'm having a heck of a time thinking how I could checkin Elastic/Node matched branches that are properly defined for a docker auto builds, so I'm now wondering if the better path is to make a script that will iterate through them locally (doing a `docker-compose build` on each) and push the images as they are built..

---

As of day-zero, this is imagined as:

- `Dockerfile` that will build a specific Kibana development env (paired with the correct node version)
- `docker-compose.yml` that will startup the specific kibana, matched with the right version of ES and mount
- `plugin-dev` into the kibana container so it can be used to building or testing

Unless some better brainstorms happen, a user of this system would presumably need to `docker exec -it [container-id-of-kibana-container] sh` to jump into the kibana image to do work

